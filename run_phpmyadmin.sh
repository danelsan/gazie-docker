#!/bin/bash


#Run the PHPMYADMIN and connect to database

docker run --name gazie-phpmyadmin -d --link db -p 8080:80 phpmyadmin/phpmyadmin



