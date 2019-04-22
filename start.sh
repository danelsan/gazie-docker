#!/bin/bash

source conf


mkdir -p $PATH_DB $PATH_BACKUP
cp -aR gazie/data/* $PATH_BACKUP/
chmod -R 777 $PATH_BACKUP

echo "Stop all service"
echo "..."
source stop.sh

docker run -d -e MYSQL_ROOT_PASSWORD=$PASS_DB -v $PATH_DB:/var/lib/mysql --name db gazie-mariadb:10.2
if [ "$GAZIE_VERSION" == "dev" ]; then
  # Mount the local path
  docker run -d --link db \
	-v $PATH_LOCAL/gazie:/var/www/html \
	-v $PATH_CONFIG:/var/www/html/config/config \
	--name phpfpm gazie-docker:${GAZIE_VERSION}
else
  # Mount whithout local
  docker run -d --link db \
	-v $PATH_CONFIG:/var/www/html/config/config \
	-v $PATH_BACKUP:/var/www/html/data \
	--name phpfpm gazie-docker:${GAZIE_VERSION}

fi
  
docker run -d --link phpfpm \
	--name opencart \
	--name nginx \
	-v $PATH_BACKUP:/var/www/html/data \
	-p $PORT_EXTERNAL:80 \
	gazie-nginx:${GAZIE_VERSION}

./run_phpmyadmin.sh


