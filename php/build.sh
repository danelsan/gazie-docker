#!/bin/bash


help() {
  echo "Use of build: "
  echo
  echo ". build.sh <gazie-version>"
  echo ". build.sh 7.31"
  return 1
}

if [ "$1" == "" ]; then
  help
else

  GAZIE_VERSION=$1

  source ../functions.sh

  getGAzie $GAZIE_VERSION `pwd` 

  ./create-dockerfile.sh

  APP_NAME=gazie-php:${GAZIE_VERSION}

  docker build -t $APP_NAME .

fi


