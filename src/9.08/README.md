# How to build

docker build -t gazie-php:9.08 .

# How to use

This is a docker container of __GAzie__.

The name is gazie-php:9.08

Example of use with docker compose (docker-compose.yml):

version: '3.8'

services:
  php:
    image: gazie-php:9.08
    hostname: gazie
    volumes:
      - ./gconfig.myconf.example.php:/var/www/html/config/config/gconfig.myconf.php
    ports:
      - "8088:80"
    depends_on:
      - db
    networks:
      - gazie_net

  db:
    image: mysql:9.1.0
    hostname: db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: gazie
      MYSQL_DATABASE: gazie
      MYSQL_USER: gazie
      MYSQL_PASSWORD: gazie
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - gazie_net

volumes:
  db_data:

networks:
  gazie_net:
    driver: overlay
    external: false

# Execute the stack

For execute the stack run:

docker stack deploy -c docker-compose-gazie.yml gazie


# Modify Password Hash

From version > 9,00 if system not modified password check into this url:

http://localhost:8088/passhash.php

You can verify hash inserted on tables.

