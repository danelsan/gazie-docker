#!/bin/bash

source conf


if [ "$GAZIE_FOLDER" != "" ]; then
  PATH_FOLDER_NGINX="/app/$GAZIE_FOLDER"
  PATH_FOLDER_PHP="/var/www/html/$GAZIE_FOLDER"
else
  PATH_FOLDER_NGINX="/app"
  PATH_FOLDER_PHP="/var/www/html"
fi  

mkdir -p $PATH_DB $PATH_BACKUP
cp -aR gazie/data/* $PATH_BACKUP/
chmod -R 777 $PATH_BACKUP

echo "Stop all service"
echo "..."
source stop.sh

docker run -d \
	-e MYSQL_ROOT_PASSWORD=$PASS_DB \
	-v $PATH_DB:/var/lib/mysql \
	-p $MYSQL_PORT:3306 \
	--name db \
	gazie-mariadb:10.2

if [ "$GAZIE_VERSION" == "dev" ]; then
  # Mount the local path
  docker run -d --link db \
	-v $PATH_LOCAL/gazie:$PATH_FOLDER_PHP \
	-v $PATH_CONFIG:$PATH_FOLDER_PHP/config/config \
	--name phpfpm gazie-docker:${GAZIE_VERSION}

  docker run -d --link phpfpm \
	--name nginx \
	-v $PATH_LOCAL/gazie:$PATH_FOLDER_NGINX \
	-v $PATH_BACKUP:$PATH_FOLDER_NGINX/data \
	-p $PORT_EXTERNAL:80 \
	gazie-nginx:${GAZIE_VERSION}

else
  # Mount whithout local
  docker run -d --link db \
	-v $PATH_CONFIG:$PATH_FOLDER_PHP/config/config \
	-v $PATH_BACKUP:$PATH_FOLDER_PHP/data \
	--name phpfpm gazie-docker:${GAZIE_VERSION}

  docker run -d --link phpfpm \
	--name nginx \
	-v $PATH_BACKUP:$PATH_FOLDER_NGINX/data \
	-p $PORT_EXTERNAL:80 \
	gazie-nginx:${GAZIE_VERSION}
fi

./run_phpmyadmin.sh


