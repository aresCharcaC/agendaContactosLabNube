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

# Copiar configuración Nginx y asegurar que los directorios de log existen
COPY docker/nginx.conf /etc/nginx/sites-available/default
RUN mkdir -p /var/log/nginx

# Copiar script de inicio
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Crear directorio de logs y establecer permisos
RUN mkdir -p /var/www/html/storage/logs
RUN touch /var/www/html/storage/logs/laravel.log
RUN chmod -R 777 /var/www/html/storage
RUN chmod -R 777 /var/www/html/bootstrap/cache

# Crear archivos .env si no existe
RUN if [ ! -f ".env" ]; then \
    cp .env.example .env || echo "No .env.example file found"; \
    sed -i 's/APP_KEY=.*/APP_KEY=base64:PLACEHOLDER/' .env; \
fi

# Exponer puerto
EXPOSE 10000

# Ejecutar script de inicio
CMD ["/start.sh"]