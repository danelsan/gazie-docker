# --- Stage 1: Git Base ---
FROM alpine:latest AS git-base 
RUN apk add --no-cache git 
# Uso il mirror corretto di danelsan puntando al tag v9.09
RUN git clone --branch v9.09 --depth 1 https://github.com/danelsan/GAzie-mirror /app

# --- Stage 2: PHP Apache ---
FROM php:8.2-apache

LABEL maintainer="Daniele Frulla <daniele.frulla@newstechnology.eu>"

# 1. Copia dei file da git-base
COPY --from=git-base /app /var/www/html

# 2. Installazione dipendenze di sistema necessarie (non-PHP)
RUN apt-get update && apt-get install -y --no-install-recommends \
        locales locales-all \
        unzip \
        sendmail \
        vim \
        libzip-dev \
        libicu-dev \
        libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Installazione Estensioni PHP tramite lo script helper ufficiale
# Questo risolve definitivamente il problema di libc-client-dev / IMAP
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions \
        gd \
        bcmath \
        gettext \
        intl \
        mysqli \
        pdo_mysql \
        soap \
        xsl \
        zip \
        imap

# 4. Abilitazione Apache Rewrite (fondamentale per GAzie)
RUN a2enmod rewrite

# 5. Configurazione PHP (Limiti di upload)
RUN printf "upload_max_filesize = 100M\npost_max_size = 100M\nmax_execution_time = 3000\nmemory_limit = 512M" > /usr/local/etc/php/conf.d/uploads.ini

# 6. Configurazione Mail
COPY php-mail.conf /usr/local/etc/php/conf.d/mail.ini

# 7. Setup Permessi
WORKDIR /var/www/html
RUN set -ex; \
    mkdir -p library/tcpdf/cache; \
    mkdir -p data/files/tmp; \
    chown -R www-data:www-data .; \
    chmod -R 755 .; \
    chmod -R 777 data library

# Locale
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# NOTA: Sendmail deve essere avviato tramite un ENTRYPOINT.sh all'avvio del container.
# Se non hai un entrypoint, usa questo comando temporaneo per test:
# CMD service sendmail start && apache2-foreground

EXPOSE 80
CMD ["apache2-foreground"]