FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add vsftpd
RUN apk add openssl

# SSL certificate
RUN mkdir -p /etc/ssl-vsftpd/private
RUN chmod 700 /etc/ssl-vsftpd/private
RUN openssl req -x509 -nodes -days 365 -newkey rsa:1024 -subj "/C=FR/ST=AuvergneRhone-alpes/L=Lyon/O=tcluadel/OU=tclaudel/CN=tclaudel" -keyout /etc/ssl-vsftpd/private/vsftpd.pem -out /etc/ssl-vsftpd/private/vsftpd.pem

COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN adduser -D user
RUN echo "user:password" | chpasswd
#RUN usermod -g sftp_uers user