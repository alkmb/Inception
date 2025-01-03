#!/bin/bash

# Initialize MySQL directories
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
chmod 777 /var/run/mysqld

# Initialize the MySQL data directory
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL with mysqld_safe
mysqld_safe --datadir=/var/lib/mysql &

# the code above works needs to go on re/up - down - up; becuase
# the build is shit at the moment

# # Wait for MySQL to be ready
# until mysqladmin ping >/dev/null 2>&1; do
#     sleep 1
# done

# Setup database and users
mysql -u root << EOF
UPDATE mysql.user SET Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE User='root';
CREATE DATABASE IF NOT EXISTS ${db_name};
CREATE USER IF NOT EXISTS '${db_user}'@'%' IDENTIFIED BY '${db_pwd}';
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'%';
FLUSH PRIVILEGES;
EOF

# Stop mysqld_safe
mysqladmin -u root shutdown

# Start MySQL normally
exec mysqld --user=mysql