# How to build

. build.sh 7.32


# How to use

This is a docker container of __GAzie__.

The name is gazie-php:<GAzie-version>

Example of use

*docker run -d \
	-v $PATH_CONFIG:/var/www/html/config/config \
	-v $PATH_DATA:/var/www/html/data/files \
	-p $PORT:80 \
	--name gazie-php \
	danelsan/gazie-php:${GAZIE_VERSION}*

$PATH_CONFIG is the path of configuration file in local
$PATH_DATA   is the path of files destination in local server
$PORT is the port exposed into localhost server

