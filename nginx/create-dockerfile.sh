#!/bin/bash

source ../conf

if [ "$GAZIE_FOLDER" != "" ]; then
  PATH_FOLDER="/app/$GAZIE_FOLDER"
else
  PATH_FOLDER="/app"
fi  


cat > Dockerfile << EOF
FROM nginx:1.14-alpine

MAiNTAINER Daniele Frulla <daniele.frulla@newstechnology.eu>

RUN  mkdir -p $PATH_FOLDER

COPY ./nginx.conf /etc/nginx/conf.d/example.com.conf
COPY gazie $PATH_FOLDER
EOF


