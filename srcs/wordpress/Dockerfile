FROM alpine:latest

RUN apk -U upgrade --no-cache
RUN apk add wget\
    && apk add php7 \
    && apk add php7-fpm \
    && apk add php7-opcache \
    && apk add php7-gd \
    && apk add php7-mysqli \
    && apk add php7-zlib \
    && apk add php7-curl \
    && apk add php7-mbstring \
    && apk add php7-json \
    && apk add php7-session

RUN wget https://wordpress.org/latest.tar.gz \
RUN tar -xvf latest.tar.gz \
RUN mv wordpress/* /www \