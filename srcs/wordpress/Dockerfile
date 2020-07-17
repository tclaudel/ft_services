 
FROM alpine:latest

RUN apk update && apk add wget && mkdir /www \
&& apk add vim php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

COPY ./srcs/wordpress.tar.gz ./ \
&& tar -xvf wordpress.tar.gz \
&& mv wordpress/* /www \
&& rm -rf /var/cache/apk/*

COPY ./srcs/wp-config.php /www/wp-config.php

EXPOSE 5050

CMD php -S 0.0.0.0:5050 -t /www/
