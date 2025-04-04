FROM php:8.2-fpm

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    nginx

# Limpiar cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP (incluir soporte PostgreSQL)
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

# Obtener Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar todo el código
COPY . .

# Instalar dependencias sin ejecutar scripts post-instalación
RUN composer install --no-interaction --prefer-dist --no-dev --optimize-autoloader --no-scripts

# Copiar configuración Nginx
COPY docker/nginx.conf /etc/nginx/sites-available/default

# Copiar script de inicio
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Crear archivos .env si no existe
RUN if [ ! -f ".env" ]; then \
    cp .env.example .env || echo "No .env.example file found"; \
    sed -i 's/APP_KEY=.*/APP_KEY=base64:PLACEHOLDER/' .env; \
fi

# Exponer puerto
EXPOSE 10000

# Ejecutar script de inicio
CMD ["/start.sh"]