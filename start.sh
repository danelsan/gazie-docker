#!/bin/bash


source conf

mkdir -p $PATH_DB $PATH_BACKUP
cp -aR gazie/data/* $PATH_BACKUP/
chmod -R 777 $PATH_BACKUP

source stop.sh

docker run -d -e MYSQL_ROOT_PASSWORD=$PASS_DB -v $PATH_DB:/var/lib/mysql --name db gazie-mariadb:${GAZIE_VERSION}
docker run -d --link db \
	-v $PATH_CONFIG:/var/www/html/config/config \
	-v $PATH_BACKUP:/var/www/html/data \
	--name phpfpm gazie-docker:${GAZIE_VERSION}
docker run -d --link phpfpm \
	--name nginx \
	-v $PATH_BACKUP:/var/www/html/data \
	-p $PORT_EXTERNAL:80 \
	gazie-nginx:${GAZIE_VERSION}


