FROM alpine:latest

RUN apk -U upgrade --no-cache
RUN apk add vsftpd \
    && apk add openssl \
    && apk add openrc \
    && apk add bash --no-cache

# SSL certificate
RUN mkdir -p /var/log/ftp/
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -subj "/C=FR/ST=AuvergneRhone-alpes/L=Lyon/O=tcluadel/OU=tclaudel/CN=tclaudel" -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache 

RUN openrc
RUN touch /run/openrc/softlevel

RUN mkdir /etc/telegraf/
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
RUN adduser -D admin
RUN echo "admin:password" | chpasswd

CMD  telegraf --config /etc/telegraf/telegraf.conf &  /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

EXPOSE 21 1024