FROM php:8.4-fpm

RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev nginx \
    && docker-php-ext-install pdo pdo_mysql mbstring

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .
RUN cp .env.example .env

RUN composer install --no-interaction --prefer-dist --no-scripts

RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 8000

CMD php artisan key:generate && php artisan serve --host=0.0.0.0 --port=8000
