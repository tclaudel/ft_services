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
COPY ./srcs/setup_mysql.sh .
COPY ./srcs/wordpress.sql .
COPY ./srcs/my.cnf /etc/mysql/my.cnf
COPY ./srcs/my.cnf /etc/my.cnf

<<<<<<< HEAD
# Add permission
RUN chmod 777 init_docker.sh
RUN chmod 777 setup_mysql.sh

ENTRYPOINT [ "./init_docker.sh" ]
=======
EXPOSE 3306
CMD ["/setup_mysql.sh"]
>>>>>>> f09968068113be6d159e29892b91dd9d792ca55c
