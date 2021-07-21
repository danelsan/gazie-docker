FROM php:7.2-apache

MAINTAINER Daniele Frulla <daniele.frulla@newstechnology.eu>

ENV GAZIE_VERSION=7.45

RUN apt-get update && apt-get install -y \
        locales locales-all \
	libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
	unzip \ 
        libxml2 \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
	sendmail  \
        vim \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install xsl \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip 

RUN apt-get update \
	&& apt-get install -y libc-client-dev libkrb5-dev \
	&& apt-get -y autoclean \
	&& apt-get -y autoremove \
	&& make -C /etc/mail \
	&& rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-install imap

RUN /etc/init.d/sendmail reload

## Create a gazie folder
WORKDIR /var/www/html/

COPY 	download_gazie.sh /download_gazie.sh
RUN  /download_gazie.sh $GAZIE_VERSION

RUN 	set -ex; \
	chown -R www-data:www-data .; chmod -R 755 .; chmod -R 777 data; chmod -R 777 library;

# All extension	
#RUN sed -i "/^;security.limit_extensions =.*/asecurity.limit_extensions = " /usr/local/etc/php-fpm.d/www.conf

RUN touch /usr/local/etc/php/conf.d/uploads.ini \
    && echo "upload_max_filesize = 100M;\npost_max_size = 100M;\nmax_execution_time = 3000;" >> /usr/local/etc/php/conf.d/uploads.ini
#ENV APACHE_DOCUMENT_ROOT /var/www

COPY config/php-mail.conf /usr/local/etc/php/conf.d/mail.ini

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN /etc/init.d/sendmail start

EXPOSE 80



