FROM alpine:latest

RUN apk -U upgrade --no-cache
RUN apk add bash lighttpd php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom

RUN sed -i 's/#   include "mod_fastcgi.conf"/include "mod_fastcgi.conf"/g' /etc/lighttpd/lighttpd.conf
RUN sed -i 's/# server.port          = 81/server.port = 5050/g' /etc/lighttpd/lighttpd.conf
RUN sed -i 's/usr\/bin\/php-cgi/usr\/bin\/php-cgi7/g' /etc/lighttpd/mod_fastcgi.conf
RUN mkdir -p /var/run/lighttpd
RUN touch /var/run/lighttpd/php-fastcgi.socket
RUN chown -R lighttpd:lighttpd /var/run/lighttpd

RUN mkdir -p /usr/share/webapps/
COPY srcs/wp-config.php /var/www/localhost/htdocs/wp-config.php
WORKDIR /usr/share/webapps/
COPY ./srcs/wordpress.tar.gz ./
RUN tar -xzvf wordpress.tar.gz > /dev/null
RUN rm wordpress.tar.gz
RUN chown -R lighttpd /usr/share/webapps/
RUN ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress

ENTRYPOINT lighttpd -D -f /etc/lighttpd/lighttpd.conf
EXPOSE 5050