FROM alpine:latest

RUN apk -U upgrade --no-cache
RUN apk add nginx bash php7 php7-common php7-fpm php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom --no-cache

RUN adduser -D -g www www


# We setup web server files and permissions
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www
RUN mkdir -p /run/nginx

RUN adduser -D admin
RUN echo "admin:password" | chpasswd

WORKDIR	/var/www/html
COPY ./srcs/wordpress.tar.gz ./
RUN tar -xzvf wordpress.tar.gz > /dev/null
RUN rm wordpress.tar.gz

COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/index.html /var/www/html/
RUN chown -R www:www /var/www/html/wordpress/
RUN chmod -R 755 /var/www/html/wordpress/
#CMD nginx -g 'daemon off;'
CMD php -S 0.0.0.0:5050 -t /var/www/html/
EXPOSE 5050