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
    libpq-dev \
    nodejs \
    npm

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar composer.json y composer.lock primero para aprovechar la caché de Docker
COPY composer.json composer.lock ./

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar todo el código
COPY . .

# Copiar .env.example a .env
RUN cp .env.example .env

# Generar clave de aplicación
RUN php artisan key:generate

# Instalar dependencias de PHP
RUN composer install --no-interaction --optimize-autoloader

# Instalar dependencias de Node.js y compilar assets
RUN npm install && npm run build

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Crear script de inicio
RUN echo '#!/bin/bash\n\
# Actualizar la configuración con variables de entorno\n\
php artisan config:cache\n\
\n\
# Ejecutar migraciones\n\
php artisan migrate --force\n\
\n\
# Iniciar Apache\n\
apache2-foreground' > /var/www/html/start.sh

RUN chmod +x /var/www/html/start.sh

# Configurar DocumentRoot de Apache para Laravel
RUN sed -i -e "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/public/g" /etc/apache2/sites-available/000-default.conf

# Exponer puerto
EXPOSE 80

# Ejecutar script de inicio
CMD ["/var/www/html/start.sh"]