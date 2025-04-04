#!/bin/bash

echo "Configurando aplicación..."

# Asegurarnos que los directorios de almacenamiento tengan permisos correctos
mkdir -p /var/www/html/storage/logs /var/www/html/storage/framework/sessions /var/www/html/storage/framework/views /var/www/html/storage/framework/cache
touch /var/www/html/storage/logs/laravel.log
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

# Ejecutar migraciones automáticamente
echo "Ejecutando migraciones..."
php artisan migrate --force

# Mostrar información de PHP y Laravel
echo "PHP version:"
php -v

# Iniciar servicios
echo "Iniciando Nginx..."
service nginx start

echo "Iniciando PHP-FPM en primer plano..."
php-fpm -F