.DEFAULT_GOAL := help

## help:       This is the help
help:     
	@echo "Use \`make <target>\` where <target> is one of"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

## build:      Build docker container: gazie-nginx:<version>, gazie-docker:version, gazie-mariadb:10.2
build:    
	./build.sh 

## start:      Start all containers infrastructure like service
start:  
	./start.sh

## stop:       Stop all infrastructure
stop:
	./stop.sh

## list:       List all docker images gazie into yout local system
list:
	docker images | grep gazie	

## clean:      Clean all data database and downloaded 
clean:  
	sudo rm -rf gazie/
	sudo rm -rf data/


