# Используем официальный образ PHP с Apache версии 8.2
FROM php:8.2-apache

# Включаем модуль переписывания URL для Apache
RUN a2enmod rewrite

# Установка необходимых пакетов для PHP
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        unzip \
        libzip-dev \
    && docker-php-ext-install -j$(nproc) zip pdo_mysql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Копируем файлы приложения в директорию Apache
COPY . /var/www/html/

# Открываем порт 80 для веб-сервера
EXPOSE 80