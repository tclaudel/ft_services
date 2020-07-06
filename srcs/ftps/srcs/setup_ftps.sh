#!/usr/bin/env bash

mkdir -p /ftps/admin
adduser --home=/ftps/admin -D admin
mkdir -p /ftps/admin/uploads
chmod 777 /ftps/admin/uploads
chown nobody:nogroup /ftps
chmod a-w /ftps

echo "admin:password" | chpasswd
echo "admin" >> etc/vsftpd/vsftpd.userlist

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf