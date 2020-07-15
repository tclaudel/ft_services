FROM alpine:latest

RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/*

VOLUME /var/lib/mysql
WORKDIR /var/lib/mysql

COPY srcs/setup_mysql.sh /setup_mysql.sh
COPY srcs/my.cnf /etc/mysql/my.cnf
RUN chmod +x /setup_mysql.sh

EXPOSE 3306
CMD ["/setup_mysql.sh"]