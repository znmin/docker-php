FROM ubuntu:22.04

LABEL maintainer="Jimmy Xie"

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=PRC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python2 dnsutils cron \
    && curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /usr/share/keyrings/ppa_ondrej_php.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && apt-get update \
    && apt-get install -y php8.1-cli php8.1-dev \
       php8.1-pgsql php8.1-sqlite3 php8.1-gd php8.1-imagick \
       php8.1-curl php8.1-memcached \
       php8.1-imap php8.1-mysql php8.1-mbstring \
       php8.1-xml php8.1-zip php8.1-bcmath php8.1-soap \
       php8.1-intl php8.1-readline php8.1-pcov \
       php8.1-msgpack php8.1-igbinary php8.1-ldap \
       php8.1-redis php8.1-swoole \
    && ( \
        curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
        && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
        && apt-get update \
        && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
        && apt-get install unixodbc-dev -y  \
    ) \
    && pecl install https://pecl.php.net/get/pdo_sqlsrv-5.11.0.tgz \
    && pecl install https://pecl.php.net/get/xlswriter-1.5.4.tgz \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN printf "; priority=20\nextension=pdo_sqlsrv.so" > /etc/php/8.1/cli/conf.d/20-pdo_sqlsrv.ini \
    && printf "; priority=20\nextension=xlswriter.so" > /etc/php/8.1/cli/conf.d/20-xlswriter.ini

COPY php.ini /etc/php/8.1/cli/conf.d/99-sail.ini
COPY openssl.cnf /etc/ssl/openssl.cnf
