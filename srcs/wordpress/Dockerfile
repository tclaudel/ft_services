 
FROM alpine:latest

RUN apk update && apk add wget && mkdir /www \
&& apk add vim php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache 
COPY ./srcs/wordpress.tar.gz ./
RUN  tar -xvf wordpress.tar.gz && mv wordpress/* /www && rm -rf /var/cache/apk/*
RUN apk add openrc
RUN openrc
RUN touch /run/openrc/softlevel
RUN mkdir /etc/telegraf/
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
COPY ./srcs/wp-config.php /www/wp-config.php
#RUN rc-update add telegraf


EXPOSE 5050

CMD telegraf --config /etc/telegraf/telegraf.conf &  php -S 0.0.0.0:5050 -t /www/
