#!/bin/bash

source conf
set -e

# Download versions
if [ "$GAZIE_VERSION" == "dev" ]; then 
  echo "Scarico versione GAZIE di Development: svn checkout https://svn.code.sf.net/p/gazie/code/trunk gazie"
  svn checkout https://svn.code.sf.net/p/gazie/code/trunk gazie
else
  if [ ! -d "$PATH_LOCAL/gazie" ]; then
    echo "Download Gazie $GAZIE_VERSION dal sito https://sourceforge.net/projects/gazie/files/gazie/$GAZIE_VERSION/gazie$GAZIE_VERSION.zip/download"
    curl -fsSL -o gazie.zip "https://sourceforge.net/projects/gazie/files/gazie/$GAZIE_VERSION/gazie$GAZIE_VERSION.zip/download"
    echo "Unzip Gazie $GAZIE_VERSION"
    unzip  -q gazie.zip  
  fi
fi


# Copy configuration and modify
echo "Modify gconfig.php..."
mkdir -p $PATH_CONFIG
cp -af gazie/config/config/gconfig.php $PATH_CONFIG/config_standard.php
sed 's/3306/3307/' < $PATH_CONFIG/config_standard.php > $PATH_CONFIG/gconfig1.php 
sed 's/localhost/db/' < $PATH_CONFIG/gconfig1.php > $PATH_CONFIG/gconfig2.php 
sed "s/\"gazie/\"$NAME_DB/" < $PATH_CONFIG/gconfig2.php > $PATH_CONFIG/gconfig3.php 
sed "s/\$Password = \"\"/\$Password = \"$PASS_DB\"/" < $PATH_CONFIG/gconfig3.php > $PATH_CONFIG/gconfig.php 
rm $PATH_CONFIG/config_standard.php $PATH_CONFIG/gconfig1.php $PATH_CONFIG/gconfig2.php $PATH_CONFIG/gconfig3.php

# Config DNS
echo "Modify DNS..."
sed "s/localhost/$DNS/" < $PATH_LOCAL/nginx/nginx.conf.example > $PATH_LOCAL/nginx/nginx.conf

# Build Nginx
echo "Build Nginx..."
cd nginx
mv ../gazie/ . 
./build.sh ${GAZIE_VERSION}
mv gazie ..

# Build PHP-FPM
echo "Build PHP-FPM..."
cd ../php-fpm
mv ../gazie/ . 
./build.sh ${GAZIE_VERSION}
mv gazie ..

# Clean
cd ..

if [ -f "$PATH_LOCAL/gazie.zip" ]; then
  echo "Delete gazie.zip"
  rm gazie.zip
fi


