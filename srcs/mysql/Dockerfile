FROM alpine:latest

RUN apk -U upgrade --no-cache
RUN apk add mysql mysql-client --no-cache

COPY srcs/my.cnf /etc/mysql/my.cnf

COPY srcs/setup_mysql.sh ./
RUN chmod +x setup_mysql.sh
RUN mkdir /app
CMD ./setup_mysql.sh
EXPOSE 3306