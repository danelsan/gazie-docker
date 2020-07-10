#!/bin/bash

DUMP_GZIP=$1

source conf

if [ "$DUMP_GZIP" == "" ]; then
	echo "No dump database insert"
	echo "Command: ./restore.sh <database.tar.gz>"	
	return 1;
fi

# Verify gzip file
VERIFY_GZIP=`gzip -t $DUMP_GZIP  && echo ok || echo bad`

if [ "VERIFY_GZIP" == "bad" ]; then
	echo "Dump Gzip not valid";
	return 1
fi

echo "-- Drop database " > run.sql
echo "DROP DATABASE $NAME_DB;" >> run.sql
echo "CREATE DATABASE $NAME_DB;" >> run.sql

echo "Drop database and create again"
cat run.sql | docker exec  -i db  /usr/bin/mysql -uroot -p$PASS_DB

rm -f run.sql

echo "Init import backup $DUMP_GZIP"
zcat $DUMP_GZIP | docker exec  -i db  /usr/bin/mysql -uroot -p$PASS_DB $NAME_DB

echo "Restore database succeded"
echo "For upgrade go to url: http://$DNS/setup/install/install.php"


