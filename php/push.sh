#!/bin/bash

help() {
  echo "Use of push: "
  echo
  echo ". push.sh <gazie-version>"
  echo ". push.sh 7.32"
  return 1
}

if [ "$1" == "" ]; then
  help
else

  GAZIE_VERSION=$1
  # Pushing the image
  docker login 
  docker tag gazie-php:${GAZIE_VERSION} danelsan/gazie-php:${GAZIE_VERSION}
  docker tag gazie-php:${GAZIE_VERSION} danelsan/gazie-php:latest

  docker push danelsan/gazie-php:${GAZIE_VERSION}
  docker push danelsan/gazie-php:latest
  docker logout
fi

