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

# Instalar extensiones PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar todo el código
COPY . .

# Copiar configuración Nginx
COPY docker/nginx.conf /etc/nginx/sites-available/default
RUN mkdir -p /var/log/nginx

# Copiar script de inicio
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Crear un archivo de prueba simple
RUN echo "<?php echo 'Laravel está funcionando. ¡Todo bien!'; ?>" > /var/www/html/public/test.php

# Exponer puerto
EXPOSE 10000

# Ejecutar script de inicio
CMD ["/start.sh"]