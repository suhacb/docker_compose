FROM php:8.3-fpm-alpine
ARG workdir
ARG TIMEZONE=UTC
ARG PUID=1000
ARG PGID=1000

# RUN apk add --no-cache shadow
# RUN groupmod -g ${PGID} www-data && usermod -u ${PUID} -g ${PGID} www-data

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
RUN echo "memory_limit=512M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

WORKDIR $workdir
EXPOSE 9000
