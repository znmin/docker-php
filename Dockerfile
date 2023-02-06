FROM php:7.4.33-cli

MAINTAINER jimmy.xie <jimmy.xie@znmin.com>

WORKDIR /root

RUN apt-get update \
    && ( \
        apt-get install libmagickwand-dev -y \
        && pecl install imagick \
        && docker-php-ext-enable imagick \
    ) \
    && pecl install redis && docker-php-ext-enable redis \
    && docker-php-ext-install pdo_mysql \
    && ( \
        apt install libzip-dev -y \
        && docker-php-ext-install zip \
    ) \
    && docker-php-ext-install bcmath \
    && ( \
        apt-get install -y libpng-dev \
        && docker-php-ext-install gd \
    ) \
    && ( \
        apt-get install unixodbc-dev -y \
        && pecl install pdo_sqlsrv \
        && docker-php-ext-enable pdo_sqlsrv \
    ) \
    && pecl install https://pecl.php.net/get/swoole-4.8.12.tgz && docker-php-ext-enable swoole \
    && ( \
        php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
        && php composer-setup.php \
        && php -r "unlink('composer-setup.php');" \
        && mv composer.phar /usr/local/bin/composer \
        && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    ) \
    && apt-get install supervisor -y \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/php.ini /usr/local/etc/php/conf.d/php.ini
COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

WORKDIR /app

EXPOSE 8000

ENTRYPOINT ["start-container"]
