#!/bin/sh
set -e

if [ "$APP_ENV" = "production" ]; then
    cp /usr/local/etc/php/conf.d/opcache.ini-enabled /usr/local/etc/php/conf.d/opcache.ini

    composer --no-dev --optimize-autoloader install
else
    composer --optimize-autoloader install
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

exec "$@"
