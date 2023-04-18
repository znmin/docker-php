FROM ubuntu:20.04

MAINTAINER Jimmy Xie

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=PRC
ENV ORACLE_HOME=/opt/oracle/instantclient_21_9
ENV LD_LIBRARY_PATH=$ORACLE_HOME

ADD instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip /opt/oracle
ADD instantclient-basic-linux.x64-21.9.0.0.0dbru.zip /opt/oracle

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python2 dnsutils libaio1 cron \
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
    && ( \
        mkdir /opt/oracle \
        && unzip /opt/oracle/instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip -d /opt/oracle/ \
        && unzip /opt/oracle/instantclient-basic-linux.x64-21.9.0.0.0dbru.zip -d /opt/oracle \
        && echo 'instantclient,/opt/oracle/instantclient_21_9/' | pecl install https://pecl.php.net/get/oci8-2.2.0.tgz \
        && cd /tmp/ext/pdo_oci  \
        && phpize \
        && ./configure --with-pdo-oci=instantclient,/opt/oracle/instantclient_21_9,21.9 \
        && make \
        && make install \
    ) \
    && pecl install https://pecl.php.net/get/pdo_sqlsrv-5.10.1.tgz \
    && pecl install https://pecl.php.net/get/xlswriter-1.5.4.tgz \
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD instantclient-basic-linux.x64-21.9.0.0.0dbru.zip /opt/oracle
ADD instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip /opt/oracle

RUN unzip /opt/oracle/instantclient-basic-linux.x64-21.9.0.0.0dbru.zip -d /opt/oracle/ \
    && unzip instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip -d /opt/oracle/

ENV LD_LIBRARY_PATH  /opt/oracle/instantclient_21_9:${LD_LIBRARY_PATH}

RUN echo 'instantclient,/opt/oracle/instantclient_12_1/' | pecl install oci8

RUN printf "; priority=20\nextension=pdo_sqlsrv.so" > /etc/php/7.4/cli/conf.d/20-pdo_sqlsrv.ini \
    && printf "; priority=20\nextension=xlswriter.so" > /etc/php/7.4/cli/conf.d/20-xlswriter.ini \
    && printf "; priority=20\nextension=oci8" > /etc/php/7.4/cli/conf.d/20-oci8.ini \
    && printf "; priority=20\nextension=pdo_oci" > /etc/php/7.4/cli/conf.d/20-pdo_oci.ini


COPY php.ini /etc/php/7.4/cli/conf.d/99-sail.ini
COPY openssl.cnf /etc/ssl/openssl.cnf
