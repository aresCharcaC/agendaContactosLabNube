#!/bin/bash

echo "Configurando aplicación..."

# Crear todos los directorios necesarios
mkdir -p /var/www/html/storage/app
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/storage/framework/cache/data
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/testing
mkdir -p /var/www/html/storage/framework/views
touch /var/www/html/storage/logs/laravel.log

# Establecer permisos
chmod -R 777 /var/www/html/storage
chmod -R 777 /var/www/html/bootstrap/cache

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

# Ejecutar migraciones automáticamente
echo "Ejecutando migraciones..."
php artisan migrate --force

# Iniciar servicios
echo "Iniciando Nginx..."
service nginx start

echo "Iniciando PHP-FPM en primer plano..."
php-fpm -F