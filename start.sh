#!/bin/bash


source conf

mkdir -p $PATH_DB

source stop.sh

docker run -d -e MYSQL_ROOT_PASSWORD=$PASS_DB -v $PATH_DB:/var/lib/mysql --name db mariadb:10.2
docker run -d --link db -v $PATH_CONFIG:/var/www/html/config/config --name phpfpm gazie-docker
docker run -d --link phpfpm --name nginx -p $PORT_EXTERNAL:80 gazie-nginx


