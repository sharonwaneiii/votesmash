# Start from official PHP FPM image
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Use faster and more reliable mirrors, set DNS if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg \
    curl

# (Optional but helpful) Set a fallback DNS in case Docker host is misconfigured
# RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    libzip-dev \
    libxslt-dev \
    libicu-dev \
    libssl-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip intl xsl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer (copy from official image)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js (18.x) and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy existing application directory contents
COPY . /var/www

# Set appropriate permissions (optional: tweak for your setup)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# Expose port (optional for Laravel Sail or similar setups)
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
