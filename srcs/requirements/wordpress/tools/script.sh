#!/bin/bash
mkdir -p /var/www/html
cd /var/www/html

# Download and setup WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar 
mv wp-cli.phar /usr/local/bin/wp

# Download WordPress
wp core download --allow-root

# Configure wp-config.php
mv /wp-config.php /var/www/html/wp-config.php

# Update database settings
sed -i "s/define( 'DB_NAME'.*/define( 'DB_NAME', '$db_name' );/g" wp-config.php
sed -i "s/define( 'DB_USER'.*/define( 'DB_USER', '$db_user' );/g" wp-config.php
sed -i "s/define( 'DB_PASSWORD'.*/define( 'DB_PASSWORD', '$db_pwd' );/g" wp-config.php
sed -i "s/define( 'DB_HOST'.*/define( 'DB_HOST', 'mariadb' );/g" wp-config.php

# Install WordPress with environment variables
wp core install --url=$DOMAIN_NAME/ \
               --title="$WP_TITLE" \
               --admin_user=$WP_ADMIN_USR \
               --admin_password=$WP_ADMIN_PWD \
               --admin_email=$WP_ADMIN_EMAIL \
               --skip-email \
               --allow-root

# Update site URLs to ensure proper redirection
wp option update home "https://$DOMAIN_NAME" --allow-root
wp option update siteurl "https://$DOMAIN_NAME" --allow-root

# Create additional user (if needed)
wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root

# Configure PHP-FPM
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
mkdir -p /run/php

/usr/sbin/php-fpm7.3 -F