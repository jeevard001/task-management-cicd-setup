#!/bin/sh
set -e

# Ensure Laravel directories exist
mkdir -p /var/www/storage/framework/{cache,sessions,views}
chown -R www-data:www-data /var/www/storage
chmod -R 775 /var/www/storage


php artisan migrate --force

# Clear cached config (must happen before key generation)
php artisan config:clear
php artisan cache:clear

# Generate key if missing
#if [ -z "$APP_KEY" ]; then
#  php artisan key:generate
#fi

# Check for pending migrations
#  php artisan migrate --force

# Cache optimized config (after migrations)
php artisan config:cache
php artisan route:cache
php artisan view:cache

exec "$@"
