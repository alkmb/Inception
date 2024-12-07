#!/bin/bash

# Ensure the MySQL directory exists and has the correct permissions
mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld

service mysql start
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '12345';
CREATE DATABASE IF NOT EXISTS $db1_name;
CREATE USER IF NOT EXISTS '$db1_user'@'%' IDENTIFIED BY '$db1_pwd';
GRANT ALL PRIVILEGES ON $db1_name.* TO '$db1_user'@'%';
FLUSH PRIVILEGES;
EOF

# Execute the SQL script
mysql -u root -p12345 < db1.sql

# Stop the MySQL service
kill $(cat /var/run/mysqld/mysqld.pid)

# Start the MySQL server in the foreground
mysqld