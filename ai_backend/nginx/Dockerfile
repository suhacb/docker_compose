FROM nginx:stable-alpine
ENV TZ=Europe/Ljubljana
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# If you are running Linux, uncomment the next line.
# RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data
