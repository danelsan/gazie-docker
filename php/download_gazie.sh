#!/bin/bash


getGAzie() {
  GAZIE_VERSION=$1
  PATH_LOCAL=$2
  USER_SOURCEFORGE=$3

  cd $PATH_LOCAL
  # Download versions
  if [ "$GAZIE_VERSION" == "dev" ]; then 
    echo "Scarico versione GAZIE di Development: svn checkout https://svn.code.sf.net/p/gazie/code/trunk gazie"
    svn checkout --username=$USER_SOURCEFORGE svn+ssh://$USER_SOURCEFORGE@svn.code.sf.net/p/gazie/code/trunk $PATH_LOCAL/gazie
    chmod -R 777 gazie
  else
    if [ ! -d "$PATH_LOCAL/gazie" ]; then
      if [ $GAZIE_VERSION == "7.15" ]; then
        LINK_DOWNLOAD="https://downloads.sourceforge.net/project/gazie/gazie/gazie$GAZIE_VERSION.zip"
      else
        LINK_DOWNLOAD="https://sourceforge.net/projects/gazie/files/gazie/$GAZIE_VERSION/gazie$GAZIE_VERSION.zip/download"
      fi
      echo "Download Gazie $GAZIE_VERSION dal sito $LINK_DOWNLOAD"
      if [ "$http_proxy" == "" ]; then
	curl -fsSL -o $PATH_LOCAL/gazie.zip "$LINK_DOWNLOAD"
      else
	curl -x $http_proxy -fsSL -o $PATH_LOCAL/gazie.zip "$LINK_DOWNLOAD"
      fi
      echo "Unzip Gazie $GAZIE_VERSION"
      unzip  -q $PATH_LOCAL/gazie.zip
      rm -f $PATH_LOCAL/gazie.zip
    fi
  fi
}

GAZIE_VERSION=$1

mkdir -p /download

getGAzie $GAZIE_VERSION /download/

mv /download/gazie/* /var/www/html

