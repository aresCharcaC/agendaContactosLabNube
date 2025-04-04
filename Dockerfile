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

# Copiar código fuente de la aplicación
COPY . /var/www/html/

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar dependencias de PHP
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Configurar DocumentRoot de Apache para Laravel
RUN sed -i -e "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/public/g" /etc/apache2/sites-available/000-default.conf

# Exponer puerto
EXPOSE 80

# Comando para iniciar Apache
CMD ["apache2-foreground"]