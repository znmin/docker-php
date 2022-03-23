FROM php:7.4.28-fpm

MAINTAINER jimmy.xie <jimmy.xie@znmin.com>

WORKDIR /root

# 加速
COPY sources.list /etc/apt/sources.list
RUN apt update && apt install wget

# 安装 pdo_mysql 扩展cat /etc/issue
RUN docker-php-ext-install pdo_mysql

# 安装 pdo_sqlsrv 扩展
RUN apt-get install gnupg2 -y \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && apt-get install unixodbc-dev -y  \
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

# 安装 opcache
RUN docker-php-ext-enable opcache

# 安装 bcmath
RUN docker-php-ext-install bcmath

# 安装
RUN wget https://github.com/tideways/php-xhprof-extension/archive/refs/tags/v5.0.4.tar.gz \
    && tar -zxvf v5.0.4.tar.gz && rm -rf v5.0.4.tar.gz && cd php-xhprof-extension-5.0.4 \
    && phpize && ./configure && make && make install && docker-php-ext-enable tideways_xhprof

COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY config/* /usr/local/etc/php/conf.d/
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY xhprof/inject.php /usr/local/etc/php-fpm.d/inject.php
COPY openssl.cnf /etc/ssl/openssl.cnf

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]
