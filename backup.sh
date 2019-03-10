#!/bin/bash

DESTINATION_SQL=$1
DATABASE=$2

source conf

if [ "$DESTINATION_SQL" == "" ]; then
	echo "No destination sql gived"
	echo "Command: ./backup.sh <destination_sql>"	
	echo "Example: ./backup.sh /mnt/backup/backup.sql"	
	exit 1;
fi

if [ "$DATABASE" != "" ]; then
	NAME_DB=$DATABASE
fi

#docker exec $NAME_CONTAINER sh -c 'exec mysqldump --skip-create-options --all-databases -uroot -p"$PASS_DB"' > $PATH_LOCAL/$FILE

echo "Init backup into $DESTINATION_SQL "
docker exec -i db mysqldump $NAME_DB -uroot -p"$PASS_DB" > $DESTINATION_SQL

echo "Backup succeded"

