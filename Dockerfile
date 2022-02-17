FROM php:8.0-fpm-alpine3.15

RUN echo "Updating system and install common dependency"

RUN apk update

RUN apk add --no-cache openrc \
    openssl \
    curl \
    procps \
    htop \
    oniguruma-dev \
    supervisor \
    make \
    git \
    libc-dev \
    gcc \
    autoconf \
    linux-headers \
    zip \
    unzip \
    libzip-dev

RUN echo "Installing mysql depedency"

RUN docker-php-ext-install pdo \
    pdo_mysql \
    mysqli \
    mbstring

RUN echo "Installing laravel media library depedency"

RUN apk add jpeg-dev \
    libpng-dev --no-cache

RUN echo "Installing exif"

RUN docker-php-ext-install exif \
    && docker-php-ext-enable exif

RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN echo "Installing zip and pcntl"

RUN  docker-php-ext-install zip && docker-php-ext-enable zip && docker-php-ext-install pcntl

RUN echo "Installing dependency for swoole"

RUN apk upgrade --update \
    && apk add --no-cache --virtual .build-deps \
    linux-headers \
    autoconf \
    gcc \
    g++ \
    build-base \
    libc-dev \
    make \
    git

RUN echo "Installing Swoole"

RUN git clone https://github.com/swoole/swoole-src.git \
        && ( \
            cd swoole-src \
            && phpize \
            && ./configure --enable-swoole-debug --enable-mysqlnd \
            && make -j$(nproc) && make install \
            ) \
        && docker-php-ext-enable swoole

RUN echo "Installing nginx"

RUN apk add nginx --no-cache

RUN echo "Add nginx to startup process"

RUN rc boot && rc-update add nginx default

RUN echo "Installing composer"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#RUN echo "Preparing WORKDIR"
#
#WORKDIR /var/www/html

EXPOSE 80

EXPOSE 443

