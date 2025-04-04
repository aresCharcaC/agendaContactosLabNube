#!/bin/bash

# Si APP_KEY está vacío, generarlo
if [ -z "$APP_KEY" ]; then
    echo "Generando APP_KEY..."
    APP_KEY=$(php artisan key:generate --show)
    export APP_KEY
fi

# Ejecutar migraciones
php artisan migrate --force

# Iniciar Apache
apache2-foreground