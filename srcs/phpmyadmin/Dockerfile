FROM alpine:latest

USER root

RUN apk -U upgrade --no-cache
RUN apk add --no-cache phpmyadmin openrc
RUN apk add bash php7 php7-common php7-fpm php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom nano --no-cache

COPY ./srcs/config.inc.php /etc/phpmyadmin/

EXPOSE 5000
CMD php -S 0.0.0.0:5000 -t /usr/share/webapps/phpmyadmin/