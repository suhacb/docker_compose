# FROM php:fpm-alpine3.16
FROM php:8.3-fpm-alpine
ARG workdir

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN apk add --no-cache libpng libpng-dev  && docker-php-ext-install gd && apk del libpng-dev
RUN set -ex \
  && apk --no-cache add \
    postgresql-dev

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql

# # LDAP
# RUN apk add --update --no-cache libldap
# RUN apk add --update --no-cache --virtual .docker-php-ldap-dependancies openldap-dev
# RUN docker-php-ext-configure ldap
# RUN docker-php-ext-install ldap
# RUN apk del .docker-php-ldap-dependancies
# RUN php -m

RUN printf '[PHP]\ndate.timezone = "${TIMEZONE}"\n' > /usr/local/etc/php/conf.d/tzone.ini

WORKDIR $workdir
EXPOSE 9000

# If you are running Linux, uncomment the next line.
# RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data
