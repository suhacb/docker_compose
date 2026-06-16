FROM php:8.4-fpm-alpine
ARG workdir

# Pinned Composer — no downloaded installer, no checksum verification needed
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN apk add --no-cache \
        autoconf g++ make \
        libpng libpng-dev \
        libzip libzip-dev \
        postgresql-dev \
        icu-dev \
        linux-headers \
    && docker-php-ext-install \
        gd \
        pdo \
        pdo_pgsql \
        pcntl \
        zip \
        bcmath \
        intl \
        opcache \
    && pecl install redis \
    && docker-php-ext-enable redis opcache \
    && apk del autoconf g++ make libpng-dev libzip-dev icu-dev

RUN echo 'date.timezone = "UTC"' > /usr/local/etc/php/conf.d/tzone.ini
RUN echo "memory_limit=512M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

WORKDIR $workdir
EXPOSE 9000
