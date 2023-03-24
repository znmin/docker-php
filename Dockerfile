FROM ubuntu:20.04

MAINTAINER Jimmy Xie

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=PRC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python2 dnsutils cron \
    && curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /usr/share/keyrings/ppa_ondrej_php.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && apt-get update \
    && apt-get install -y php7.4-cli php7.4-dev \
       php7.4-pgsql php7.4-sqlite3 php7.4-gd php7.4-imagick \
       php7.4-curl php7.4-memcached \
       php7.4-imap php7.4-mysql php7.4-mbstring \
       php7.4-xml php7.4-zip php7.4-bcmath php7.4-soap \
       php7.4-intl php7.4-readline php7.4-pcov \
       php7.4-msgpack php7.4-igbinary php7.4-ldap \
       php7.4-redis php7.4-swoole \
    && ( \
        curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
        && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
        && apt-get update \
        && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
        && apt-get install unixodbc-dev -y  \
    ) \
    && pecl install https://pecl.php.net/get/pdo_sqlsrv-5.10.1.tgz \
    && pecl install https://pecl.php.net/get/xlswriter-1.5.4.tgz \
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN printf "; priority=20\nextension=pdo_sqlsrv.so" > /etc/php/7.4/cli/conf.d/20-pdo_sqlsrv.ini \
    && printf "; priority=20\nextension=xlswriter.so" > /etc/php/7.4/cli/conf.d/20-xlswriter.ini

COPY php.ini /etc/php/7.4/cli/conf.d/99-sail.ini
COPY openssl.cnf /etc/ssl/openssl.cnf
