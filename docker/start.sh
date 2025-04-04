#!/bin/bash

# Generar clave si no existe
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:PLACEHOLDER" ]; then
    echo "Generando APP_KEY..."
    php artisan key:generate --force
fi

# Ejecutar migraciones automáticamente
php artisan migrate --force

# Iniciar servicios
service nginx start
php-fpm