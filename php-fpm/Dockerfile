FROM php:7.3.33-fpm

MAINTAINER jimmy.xie <jimmy.xie@znmin.com>

WORKDIR /root

# 加速
COPY sources.list /etc/apt/sources.list
RUN apt update && apt install wget

# 安装 pdo_mysql 扩展cat /etc/issue
RUN docker-php-ext-install pdo_mysql

# 安装 pdo_sqlsrv 扩展
RUN apt-get install unixodbc-dev -y  \
    && pecl install pdo_sqlsrv \
    && docker-php-ext-enable pdo_sqlsrv

# 安装 redis 扩展 \
RUN pecl install redis \
    && docker-php-ext-enable redis

# 安装 composer
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# 安装 gd
RUN apt-get install -y \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libpng-dev \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd

# 安装 zip
RUN apt install libzip-dev/stable -y \
    && docker-php-ext-install zip

WORKDIR /app
