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

# Crear un archivo de prueba
echo "<?php phpinfo(); ?>" > /var/www/html/public/phpinfo.php

# Iniciar servicios
echo "Iniciando Nginx..."
service nginx start

echo "Iniciando PHP-FPM en primer plano..."
php-fpm -F