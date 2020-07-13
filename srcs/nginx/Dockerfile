FROM alpine:latest

RUN apk -U upgrade --no-cache
RUN apk add openssl \
    && apk add nginx \
    && apk add openssh \
    && apk add bash \
    && apk add zsh --no-cache

RUN adduser -D -g www www

# We setup web server files and permissions
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www
RUN mkdir -p /run/nginx

# Create SSL
RUN adduser -D admin
RUN echo "admin:password" | chpasswd
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST=AuvergneRhone-alpes/L=Lyon/O=tcluadel/OU=tclaudel/CN=tclaudel" -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# Create SSH
RUN mkdir -p /etc/ssh
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssh/ssh_host_rsa_key -keyout /etc/ssh/ssh_host_rsa_key -subj "/C=FR/ST=AuvergneRhone-alpes/L=Lyon/O=tcluadel/OU=tclaudel/CN=tclaudel"
RUN chmod 600 /etc/ssh/ssh_host_rsa_key

COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/index.html /var/www/html/
CMD /usr/sbin/sshd; nginx -g 'daemon off;'

EXPOSE 22 80 443