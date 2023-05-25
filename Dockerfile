#Deployment
FROM php:8.2-apache

LABEL version="1.0"

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY ./deployment/vhosts.conf /etc/apache2/sites-enabled

RUN apt-get update \
    && apt-get install -y --no-install-recommends locales apt-utils git libicu-dev g++ libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev;

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
  mv composer.phar /usr/local/bin/composer

RUN curl -sS https://get.symfony.com/cli/installer | bash

RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

RUN chmod -R 767 /root/.symfony5
  
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql gd opcache intl zip calendar dom mbstring zip gd xsl

RUN pecl install apcu && docker-php-ext-enable apcu

WORKDIR /var/www/html
RUN mkdir quaiantique
WORKDIR /var/www/html/quaiantique
COPY composer.json ./
RUN composer install --no-scripts --no-autoloader
ENV COMPOSER_ALLOW_SUPERUSER=1

COPY . ./

RUN composer dump-autoload --optimize && \
    composer run-script post-install-cmd

