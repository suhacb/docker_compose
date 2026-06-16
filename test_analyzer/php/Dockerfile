FROM php:8.3-fpm-alpine
ARG workdir
ARG TIMEZONE=UTC
ARG PUID=1000
ARG PGID=1000

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN apk add --no-cache libpng libpng-dev  && docker-php-ext-install gd && apk del libpng-dev
RUN set -ex \
  && apk --no-cache add \
    postgresql-dev

RUN apk add --no-cache libzip-dev && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

RUN printf '[PHP]\ndate.timezone = "${TIMEZONE}"\n' > /usr/local/etc/php/conf.d/tzone.ini
RUN echo "memory_limit=512M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

WORKDIR $workdir
EXPOSE 9000

# If you are running Linux, uncomment the next line.
# RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data
