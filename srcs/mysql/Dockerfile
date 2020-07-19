FROM alpine:latest

# installation
RUN apk update \
&& apk add mariadb mariadb-client && apk add --no-cache --upgrade bash \
&& rm -rf /var/cache/apk/*
RUN apk add openrc vim --no-cache
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache 

RUN openrc
RUN touch /run/openrc/softlevel
RUN rc-update add telegraf

RUN mkdir /etc/telegraf/
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
# RUN service mysql start
RUN mysql --version

# Copy initialisation script
COPY ./srcs/init_docker.sh .
COPY ./srcs/setup.sh .
COPY ./srcs/wordpress.sql .
COPY ./srcs/my.cnf /etc/mysql/my.cnf
COPY ./srcs/my.cnf /etc/my.cnf
#COPY ./srcs/requests /requests

# Add permission
RUN chmod 777 init_docker.sh
RUN chmod 777 setup.sh

ENTRYPOINT telegraf --config /etc/telegraf/telegraf.conf &  ./init_docker.sh
