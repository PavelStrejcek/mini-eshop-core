FROM php:8.2.4-fpm
RUN apt-get update \
    && apt-get install -y \
        git \
        unzip \
        zlib1g-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        libpq-dev \
        libjpeg-dev \
        libwebp-dev \
        libpng-dev \
        openssl \
        libssh2-1 \
        libssh2-1-dev \
        python2.7 \
        nodejs \
        npm \
        libc-client-dev \
        libkrb5-dev
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure gd --enable-gd --with-jpeg --with-webp \
    && docker-php-ext-configure exif --enable-exif \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install \
        opcache \
        zip \
        intl \
        pgsql \
        pdo_mysql \
        pdo_pgsql \
        gd \
        exif \
        imap \
        soap

# install locale
RUN apt update && apt install -y locales
RUN localedef -i cs_CZ -c -f UTF-8 -A /usr/share/locale/locale.alias cs_CZ.UTF-8
RUN localedef -i sk_SK -c -f UTF-8 -A /usr/share/locale/locale.alias sk_SK.UTF-8
ENV LANG cs_CZ.UTF-8
ENV LANGUAGE cs_CZ.UTF-8
ENV LC_CTYPE cs_CZ.UTF-8
ENV LC_ALL cs_CZ.UTF-8
RUN sed -i '/^#.* cs_CZ.UTF-8/s/^# //' /etc/locale.gen
RUN sed -i '/^#.* sk_SK.UTF-8/s/^# //' /etc/locale.gen
RUN locale-gen

COPY php.ini /usr/local/etc/php/conf.d/
ARG WWW_DATA_UID=1000
ARG WWW_DATA_GID=1000
RUN usermod -u $WWW_DATA_UID www-data
RUN groupmod -g $WWW_DATA_GID www-data
RUN chown $WWW_DATA_UID:$WWW_DATA_UID /var/www

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.5.5

USER www-data
WORKDIR /var/www/html
