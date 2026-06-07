FROM php:8.4-fpm-alpine
ARG workdir

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN apk add --no-cache libpng libpng-dev && docker-php-ext-install gd && apk del libpng-dev
RUN apk add --no-cache postgresql-dev
RUN docker-php-ext-install pdo pdo_pgsql

RUN echo 'date.timezone = "UTC"' > /usr/local/etc/php/conf.d/tzone.ini
RUN echo "memory_limit=512M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

WORKDIR $workdir
EXPOSE 9000
