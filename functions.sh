#!/bin/bash

getGAzieMirror() {
  GAZIE_VERSION=$1
  PATH_LOCAL=$2

  echo "Scarico versioni GAzie da GAzie-mirror in github"
  # Download versions
  if [ "$GAZIE_VERSION" == "dev" ]; then
    echo "Scarico versione GAZIE di Development: git clone https://github.com/danelsan/GAzie-mirror gazie"
    git clone https://github.com/danelsan/GAzie-mirror gazie
    chmod -R 777 gazie
  else
    echo "Scarico versione GAZIE di Development: git clone -b v$GAZIE_VERSION https://github.com/danelsan/GAzie-mirror gazie"
    git clone -b v$GAZIE_VERSION https://github.com/danelsan/GAzie-mirror gazie
    chmod -R 777 gazie 
  fi
}


getGAzie() {
  GAZIE_VERSION=$1
  PATH_LOCAL=$2
  USER_SOURCEFORGE=$3

  # Download versions
  if [ "$GAZIE_VERSION" == "dev" ]; then 
    echo "Scarico versione GAZIE di Development: svn checkout https://svn.code.sf.net/p/gazie/code/trunk gazie"
    svn checkout --username=$USER_SOURCEFORGE svn+ssh://$USER_SOURCEFORGE@svn.code.sf.net/p/gazie/code/trunk gazie
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
	curl -fkSL -o gazie.zip "$LINK_DOWNLOAD"
      else
	curl -x $http_proxy -fSLk -o gazie.zip "$LINK_DOWNLOAD"
      fi
      echo "Unzip Gazie $GAZIE_VERSION"
      unzip  -q gazie.zip
      rm -f gazie.zip
    fi
  fi

}

