FROM alpine:latest

USER root

RUN apk -U upgrade --no-cache
RUN apk add bash mysql mysql-client --no-cache

COPY srcs/my.cnf /etc/mysql/my.cnf

RUN mkdir -p /run/mysqld
RUN cp -rp /var/run/mysqld /var/run/mysqld.bak

COPY srcs/setup_mysql.sh ./
RUN chmod +x setup_mysql.sh
RUN mkdir /app

CMD ./setup_mysql.sh

EXPOSE 3306