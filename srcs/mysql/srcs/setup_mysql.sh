
#!/bin/sh

if [ ! -d /app/mysql/mysql ]
then
	echo Creating initial database...
	mysql_install_db --user=root > /dev/null
	echo Done!
fi

if [ ! -d /run/mysqld ]
then
	mkdir -p /run/mysqld
fi

tfile=`mktemp`
if [ ! -f "$tfile" ]
then
	echo Cannot create temp file!
	exit 1
fi

echo Root password is $MYSQL_ROOT_PASSWORD

cat << EOF > $tfile
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO "$MYSQL_ROOT"@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
EOF

echo Bootstraping...
if ! /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
then
	echo Cannot bootstrap mysql!
	exit 1
fi
rm -f $tfile
echo Bootstraping done!

echo Launching mysql server!
exec /usr/bin/mysqld --user=root --console