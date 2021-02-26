FROM php:7.4.1-fpm

RUN apt-get update \
  && apt-get install -y wget git unzip libpq-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
  && : 'Install Node.js' \
  &&  curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs \
  && : 'Install PHP Extensions' \
  && docker-php-ext-install -j$(nproc) pdo_pgsql \
  && mkdir /var/www/html/workdir

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY . /var/www/html/workdir
WORKDIR /var/www/html/workdir
RUN composer install
CMD ["php","artisan", "serve", "--host", "0.0.0.0", "--port", "8085"]
