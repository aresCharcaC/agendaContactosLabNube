FROM php:8.2-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    libpq-dev

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql gd

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar todo el proyecto
COPY . .

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Crear un archivo de autoload personalizado antes de ejecutar composer
RUN echo "<?php\n\nfunction files() {\n    return [];\n}\n" > /var/www/html/bootstrap/helpers.php

# Modificar composer.json para incluir nuestro helper temporal
RUN sed -i 's/"autoload": {/"autoload": {\n        "files": ["bootstrap\/helpers.php"],/g' composer.json

# Instalar dependencias sin desarrollo
RUN composer install --no-interaction --no-dev --no-scripts

# Generar autoloader
RUN composer dump-autoload --optimize

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Crear script de inicio
RUN echo '#!/bin/bash\n\
# Generar APP_KEY si no existe\n\
if [ -z "$APP_KEY" ]; then\n\
    echo "Generando APP_KEY..."\n\
    php artisan key:generate\n\
fi\n\
\n\
# Ejecutar migraciones automáticamente\n\
echo "Ejecutando migraciones..."\n\
php artisan migrate --force\n\
\n\
# Iniciar Apache\n\
echo "Iniciando Apache..."\n\
apache2-foreground' > /var/www/html/start.sh

# Hacer ejecutable el script de inicio
RUN chmod +x /var/www/html/start.sh

# Configurar DocumentRoot de Apache para Laravel
RUN sed -i -e "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/public/g" /etc/apache2/sites-available/000-default.conf

# Exponer puerto
EXPOSE 80

# Usar nuestro script de inicio personalizado
CMD ["/var/www/html/start.sh"]