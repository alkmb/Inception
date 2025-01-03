#!/bin/bash

# Initialize MySQL directories
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld

# Initialize the MySQL data directory
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Setup database and users
mysql -u root << EOF
UPDATE mysql.user SET Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE User='root';
CREATE DATABASE IF NOT EXISTS ${db_name};
CREATE USER IF NOT EXISTS '${db_user}'@'%' IDENTIFIED BY '${db_pwd}';
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'%';
FLUSH PRIVILEGES;
EOF

# Kill temporary MySQL
pkill mysqld
sleep 5

# Start MySQL normally
exec mysqld --user=mysql