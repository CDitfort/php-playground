FROM php:8.2-apache

# Install system deps
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libssl-dev \
    && docker-php-ext-install zip pdo pdo_mysql mysqli

# Install Xdebug
RUN pecl install xdebug-3.3.1 \
    && docker-php-ext-enable xdebug

# Enable Apache modules (rewrite for WordPress, SSL for HTTPS, vhost_alias for dynamic subdomains)
RUN a2enmod rewrite ssl vhost_alias

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy custom php.ini
COPY php.ini /usr/local/etc/php/conf.d/custom.ini

# Copy virtual host configs
COPY apache/vhosts.conf /etc/apache2/sites-available/000-default.conf
COPY apache/vhosts-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Generate self-signed SSL certificate
RUN mkdir -p /etc/apache2/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/apache2/ssl/server.key \
    -out /etc/apache2/ssl/server.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Enable SSL site
RUN a2ensite default-ssl

WORKDIR /var/www/html
