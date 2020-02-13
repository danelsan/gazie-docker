#!/bin/bash

GAZIE_VERSION=$1
PATH_CONFIG=$2
PATH_DATA=$3
PORT=$4

docker run -d --link db \
	-v $PATH_CONFIG:/var/www/html/config/config \
	-v $PATH_DATA:/var/www/html/data/files \
	-p $PORT:80 \
	--name gazie-php \
	gazie-php:${GAZIE_VERSION}


