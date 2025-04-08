FROM public.ecr.aws/docker/library/php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    default-mysql-client && \
    docker-php-ext-configure gd && \
    docker-php-ext-install pdo pdo_mysql gd zip opcache

# Install Composer
COPY --from=public.ecr.aws/docker/library/composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy only composer files first
COPY composer.json composer.lock ./

# Install PHP dependencies (without scripts)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Now copy the full application
COPY . .

# Dummy .env and env var
COPY .env.example .env
ENV APP_ENV=production

# Run composer scripts after all files are in place
RUN composer run-script post-autoload-dump

# Permissions and entrypoint
RUN chown -R www-data:www-data storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache && \
    chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["php-fpm"]
