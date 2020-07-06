FROM alpine:latest

RUN apk -U upgrade --no-cache
RUN apk add vsftpd \
    && apk add openssl \
    && apk add bash

# SSL certificate
RUN mkdir -p /etc/ssl-vsftpd/private
RUN chmod 700 /etc/ssl-vsftpd/private
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -subj "/C=FR/ST=AuvergneRhone-alpes/L=Lyon/O=tcluadel/OU=tclaudel/CN=tclaudel" -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY srcs/setup_ftps.sh /
RUN chmod +x setup_ftps.sh
CMD ./setup_ftps.sh

EXPOSE 20 21 21000-21001