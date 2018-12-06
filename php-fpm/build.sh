#!/bin/bash

GAZIE_VERSION=$1

APP_NAME=gazie-docker:${GAZIE_VERSION}

docker build -t $APP_NAME .


