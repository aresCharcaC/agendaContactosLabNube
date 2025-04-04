#!/bin/bash

echo "Configurando aplicación..."

# Asegurarnos que el directorio de almacenamiento tiene permisos correctos
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

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

# Mostrar la URL de la aplicación
echo "URL de la aplicación: $APP_URL"

# Iniciar servicios
echo "Iniciando Nginx..."
service nginx start

echo "Iniciando PHP-FPM en primer plano..."
php-fpm -F