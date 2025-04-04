#!/bin/bash

echo "Configurando aplicación..."

# Asegurarnos que el directorio de almacenamiento tiene permisos correctos
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Verificar que los directorios críticos existen
mkdir -p /var/www/html/storage/logs
touch /var/www/html/storage/logs/laravel.log
chmod 775 /var/www/html/storage/logs/laravel.log

# Generar clave si no existe
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:PLACEHOLDER" ]; then
    echo "Generando APP_KEY..."
    php artisan key:generate --force
fi

# Limpiar y optimizar configuración
echo "Limpiando caché de configuración..."
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear

# Mostrar información de PHP y Laravel
php -v
php -m
php artisan --version

# Ejecutar migraciones automáticamente
echo "Ejecutando migraciones..."
php artisan migrate --force

# Mostrar la URL de la aplicación
echo "URL de la aplicación: $APP_URL"
echo "Configuración de base de datos:"
echo "DB_CONNECTION: $DB_CONNECTION"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_DATABASE: $DB_DATABASE"
echo "DB_USERNAME: $DB_USERNAME"

# Iniciar servicios
echo "Iniciando Nginx..."
service nginx start

echo "Iniciando PHP-FPM en primer plano..."
php-fpm -F