FROM alpine:latest

# installation
RUN apk update \
&& apk add mariadb mariadb-client && apk add --no-cache --upgrade bash \
&& rm -rf /var/cache/apk/*
RUN apk add openrc vim --no-cache

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

ENTRYPOINT [ "./init_docker.sh" ]
