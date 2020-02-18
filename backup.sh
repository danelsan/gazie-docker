#!/bin/bash

DESTINATION_SQL=$1
DATABASE=$2
NOW=`date +"%Y%m%d%H%M%S"`

source conf

help() {
	echo "No destination sql gived"
	echo "Command: ./backup.sh date_<destination_sql> <name_db>"
	echo
	echo
	echo "name_db not needed. It's into configuration file"
	echo
	echo "Example: ./backup.sh /mnt/backup"	
	return 1
}

backup() {
  DESTINATION_SQL=$1
  PASS_DB=$2
  DATABASE=$3
  NOW=`date +"%Y%m%d%H%M%S"`

  if [ "$DATABASE" != "" ]; then
	NAME_DB=$DATABASE
  fi

  FILE_SQL=${DESTINATION_SQL}/${NOW}_${NAME_DB}.sql

  echo "Init backup into $DESTINATION_SQL"
  docker exec -i db mysqldump $NAME_DB -uroot -p"$PASS_DB" > ${FILE_SQL}
  echo "File compress"
  gzip ${FILE_SQL}
  echo "Backup succeded"
}

if [ ! -d "$DESTINATION_SQL" ]; then
  help 
else
  backup $DESTINATION_SQL $PASS_DB $DATABASE
fi

