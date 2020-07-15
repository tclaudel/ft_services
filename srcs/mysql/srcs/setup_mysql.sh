#!/usr/bin/env bash

mysql_install_db --user=__DB_USER__
tmp=sql_tmp

echo -ne "CREATE DATABASE wordpress;\n
ALTER USER root@localhost IDENTIFIED VIA mysql_native_password;\n
CREATE user user@localhost identified by 'password';\n
SET PASSWORD = PASSWORD('password');\n
grant all privileges on wordpress.* to user@localhost;\n
FLUSH PRIVILEGES;\n" >> $tmp

/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tmp
rm -rf $tmp

exec /usr/bin/mysqld --user=root