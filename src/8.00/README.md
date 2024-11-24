# How to build

docker build -t gazie-php:8.00 .

# How to use

This is a docker container of __GAzie__.

The name is gazie-php:8.00

Example of use with docker compose (docker-compose.yml):

version: '3.8'

services:
  php:
    image: gazie-php:8.00
    container_name: gazie
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
    container_name: db
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


