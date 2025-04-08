#!/bin/sh
set -e

# Ensure Laravel directories exist
mkdir -p /var/www/storage/framework/{cache,sessions,views}
chown -R www-data:www-data /var/www/storage
chmod -R 775 /var/www/storage

# Clear cached config (must happen before key generation)
php artisan config:clear
php artisan cache:clear

# Generate key if missing
#if [ -z "$APP_KEY" ]; then
#  php artisan key:generate
#fi

# Check for pending migrations
if php artisan migrate:status | grep -q 'Pending'; then
  php artisan migrate --force
fi

# Cache optimized config (after migrations)
php artisan config:cache
php artisan route:cache
php artisan view:cache

exec "$@"
