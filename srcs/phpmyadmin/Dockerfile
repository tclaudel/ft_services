FROM alpine:latest

RUN apk update && apk upgrade && apk add bash \
&& apk add vim php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz \
&& tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz \
&& mv phpMyAdmin-4.9.0.1-all-languages /www \
&& rm -rf /var/cache/apk/*
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache 
RUN apk add openrc
RUN openrc
RUN touch /run/openrc/softlevel

RUN mkdir /etc/telegraf/
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
COPY ./srcs/config.inc.php /www/config.inc.php

EXPOSE 5000

CMD  telegraf --config /etc/telegraf/telegraf.conf &  php -S 0.0.0.0:5000 -t /www/