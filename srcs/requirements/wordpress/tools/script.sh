#!/bin/bash

# Clear existing WordPress files
rm -rf /var/www/html/*

cd /var/www/html

# Download and setup WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar 
mv wp-cli.phar /usr/local/bin/wp

# Download WordPress
wp core download --allow-root

# Configure wp-config.php
cp /wp-config.php /var/www/html/

# Wait for MariaDB
while ! mysqladmin ping -h"mariadb" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Install WordPress with environment variables
wp core install --url=$DOMAIN_NAME/ \
               --title="$WP_TITLE" \
               --admin_user=$WP_ADMIN_USR \
               --admin_password=$WP_ADMIN_PWD \
               --admin_email=$WP_ADMIN_EMAIL \
               --skip-email \
               --allow-root

# Configure PHP-FPM
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
mkdir -p /run/php
/usr/sbin/php-fpm7.3 -F