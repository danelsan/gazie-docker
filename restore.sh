#!/bin/bash

DUMP_GZIP=$1

source conf

if [ "$DUMP_GZIP" == "" ]; then
	echo "No dump database insert"
	exit 1;
fi

# Verify gzip file
VERIFY_GZIP=`gzip -t $DUMP_GZIP  && echo ok || echo bad`

if [ "VERIFY_GZIP" == "bad" ]; then
	echo "Dump Gzip not valid";
	exit 1
fi


zcat $DUMP_GZIP | docker exec  -i db  /usr/bin/mysql -uroot -p$PASS_DB $NAME_DB

echo "Restore database succeded"
echo "For upgrade go to url: http://$DNS/setup/install/install.php"

