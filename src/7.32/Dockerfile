FROM alpine:latest AS git-base 

RUN apk add --no-cache git 

RUN git clone --branch v7.32 https://github.com/danelsan/GAzie-mirror /app

FROM php:7.4-apache

MAINTAINER Daniele Frulla <daniele.frulla@newstechnology.eu>

COPY --from=git-base /app /var/www/html

RUN apt-get update && apt-get install -y \
        locales locales-all \
	libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
	unzip \
        libxml2 \
        libzip-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
	libicu-dev \
	sendmail  \
        vim \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype --with-jpeg  \
    && docker-php-ext-configure intl \
    && docker-php-ext-install xsl \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) intl

RUN apt-get update \
    && apt-get install -y libc-client-dev libkrb5-dev \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && make -C /etc/mail \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

RUN /etc/init.d/sendmail reload

WORKDIR /var/www/html

RUN set -ex; \
  mkdir -p library/tcpdf/cache; \
  chown -R www-data:www-data .; chmod -R 755 .; chmod -R 777 data; chmod -R 777 library;

# All extension	
#RUN sed -i "/^;security.limit_extensions =.*/asecurity.limit_extensions = " /usr/local/etc/php-fpm.d/www.conf

RUN touch /usr/local/etc/php/conf.d/uploads.ini \
    && echo "upload_max_filesize = 100M;\npost_max_size = 100M;\nmax_execution_time = 3000;" >> /usr/local/etc/php/conf.d/uploads.ini

COPY php-mail.conf /usr/local/etc/php/conf.d/mail.ini

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN /etc/init.d/sendmail start

EXPOSE 80

