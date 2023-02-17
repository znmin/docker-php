FROM php:7.4-cli

MAINTAINER jimmy.xie <jimmy.xie@znmin.com>

WORKDIR /root

RUN apt-get update \
    && apt-get install -y gnupg2 libpng-dev libzip-dev libmagickwand-dev \
    && ( \
        curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
        && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
        && apt-get update \
        && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
        && apt-get install unixodbc-dev -y  \
    ) \
    && ( \
        docker-php-ext-configure gd \
        && docker-php-ext-install gd \
    ) \
    && pecl install redis \
    && pecl install imagick \
    && pecl install pdo_sqlsrv \
    && pecl install inotify \
    && pecl install https://pecl.php.net/get/swoole-4.8.12.tgz \
    && docker-php-ext-enable redis imagick pdo_sqlsrv inotify swoole \
    && docker-php-ext-install zip bcmath pdo_mysql \
    && ( \
        php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
        && php composer-setup.php \
        && php -r "unlink('composer-setup.php');" \
        && mv composer.phar /usr/local/bin/composer \
    ) \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY openssl.cnf /etc/ssl/openssl.cnf

WORKDIR /app

EXPOSE 5200

ENTRYPOINT ["php", "/app/bin/laravels", "start"]