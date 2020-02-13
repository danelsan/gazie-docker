#!/bin/bash


GAZIE_VERSION=$1

source ../functions.sh

getGAzie $GAZIE_VERSION `pwd` 

./create-dockerfile.sh

APP_NAME=gazie-php:${GAZIE_VERSION}

docker build -t $APP_NAME .


