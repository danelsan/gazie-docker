#!/bin/bash

if [ ! -f conf ]; then
  echo "File di configurazione not trovato"
  echo "Eseguire: "
  echo "cp .config.origin conf"
  exit 
fi

source conf
source functions.sh

set -e

# Proxy configuration setting
if [ "$HTTP_PROXY" != "" ]; then
  export http_proxy="$HTTP_PROXY"
fi
if [ "$HTTPS_PROXY" != "" ]; then
  export https_proxy="$HTTPS_PROXY"
fi

# Control gazie directory
if [ -d "$PATH_LOCAL/gazie" ]; then
  echo "Esiste la directory $PATH_LOCAL/gazie! La elimino!";
  rm -rf $PATH_LOCAL/gazie
  sleep 5
fi

# Download versions 
getGAzieMirror $GAZIE_VERSION $PATH_LOCAL
#getGAzie $GAZIE_VERSION $PATH_LOCAL $USER_SOURCEFORGE


# Copy configuration and modify
echo "Modify gconfig.php..."
mkdir -p $PATH_CONFIG

if [[ "$GAZIE_VERSION" < "7.16" ]]; then
  # Valid for gazie version < 7.16
  echo "Version < 7.16"
  sed 's/3306/3307/' < gazie/config/config/gconfig.php | sed 's/localhost/db/' | sed "s/\"gazie/\"$NAME_DB/" | sed "s/\$Password = \"\"/\$Password = \"$PASS_DB\"/" > $PATH_CONFIG/gconfig.myconf.php
  cp $PATH_CONFIG/gconfig.myconf.php $PATH_CONFIG/gconfig.php
else
  # Valid for gazie version >= 7.16
  echo "Version >= 7.16"
  cp -af gazie/config/config/gconfig.php $PATH_CONFIG/gconfig.php
  sed 's/3306/3307/' < gazie/config/config/gconfig.myconf.default.php | sed 's/localhost/db/' | sed "s/'gazie/'$NAME_DB/" | sed "s/Password', '/Password', '$PASS_DB/" > $PATH_CONFIG/gconfig.myconf.php
fi

# Config DNS
echo "Modify DNS..."
sed "s/localhost/$DNS/" < nginx/nginx.conf.example > nginx/nginx.conf

# Build Nginx
echo "Build Nginx..."
cd nginx
rm -rf gazie 
mv ../gazie/ . 
./build.sh ${GAZIE_VERSION}
mv gazie ..

# Build PHP-FPM
echo "Build PHP-FPM..."
cd ../php-fpm
rm -rf gazie 
mv ../gazie/ . 
./build.sh ${GAZIE_VERSION}
mv gazie ..

# Build Database in Strict-mode
cd ../mariadb
./build.sh ${GAZIE_VERSION}


# Clean
cd ..

if [ -f "$PATH_LOCAL/gazie.zip" ]; then
  echo "Deleted gazie.zip"
  rm $PATH_LOCAL/gazie.zip
fi


