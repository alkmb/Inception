#!/bin/bash

# Generate a self-signed SSL certificate valid for 365 days
# -x509: Generate self-signed cert
# -nodes: No password protection for private key
# -days 365: Certificate validity period
# -newkey rsa:2048: Generate new 2048-bit RSA key
# -subj: Certificate subject details (Country, Location, Organization, etc.)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out $CERTS_ -subj "/C=ES/L=CA/O=42/OU=student/CN=akambou.42.fr"

# First part of NGINX server configuration
# Create/overwrite the default site configuration
echo "
server {
    # Listen on port 443 for HTTPS connections (IPv4 and IPv6)
    listen 443 ssl;
    listen [::]:443 ssl;

    # Server name commented out (domain name configuration)
    #server_name www.$DOMAIN_NAME $DOMAIN_NAME;

    # SSL certificate paths
    ssl_certificate $CERTS_;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;" > /etc/nginx/sites-available/default

# Second part of NGINX configuration
# Append additional settings to the configuration file
echo '
    # Only allow TLS 1.3 protocol
    ssl_protocols TLSv1.3;

    # Default index file and root directory
    index index.php;
    root /var/www/html;

    # PHP file processing configuration
    location ~ [^/]\.php(/|$) { 
            try_files $uri =404;            # Check if PHP file exists, return 404 if not
            fastcgi_pass wordpress:9000;    # Forward PHP requests to WordPress container
            include fastcgi_params;          # Include default FastCGI parameters
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  # Set script filename
        }
} ' >>  /etc/nginx/sites-available/default

# Start NGINX in foreground mode (required for Docker)
nginx -g "daemon off;"
