FROM php:7.2-fpm

MAINTAINER Daniele Frulla <daniele.frulla@newstechnology.eu>

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
	unzip \ 
        libxml2 \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
        vim \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install xsl \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip 

RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap

COPY 	gazie /var/www/html
RUN 	set -ex; \
	chown -R www-data:www-data .; chmod -R 755 .; chmod -R 777 data; chmod -R 777 library;

# All extension	
RUN sed -i "/^;security.limit_extensions =.*/asecurity.limit_extensions = " /usr/local/etc/php-fpm.d/www.conf

#ENV APACHE_DOCUMENT_ROOT /var/www

EXPOSE 9000

