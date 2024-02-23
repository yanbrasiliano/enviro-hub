FROM php:7.4-fpm

# Defina o UID desejado
ARG UID=1000

# Instale as dependências do sistema
RUN apt-get update && apt-get install -y \
  git \
  curl \
  libpng-dev \
  libonig-dev \
  libxml2-dev \
  zip \
  unzip \
  libpq-dev \
  nginx \
  supervisor

# Instale as extensões do PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd pdo_pgsql

# Configure o usuário e o grupo para o Nginx e PHP-FPM
RUN usermod -u ${UID} www-data && groupmod -g ${UID} www-data

# Instale o Xdebug
RUN pecl install xdebug-2.9.8 && docker-php-ext-enable xdebug

# Configurações adicionais do PHP
COPY ./docker/php/conf.d/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY ./docker/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Configuração do Nginx
COPY ./docker/nginx/default.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Configuração do Supervisor
COPY ./docker/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Limpeza de cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Defina o diretório de trabalho
WORKDIR /var/www/html

# Copie o aplicativo
COPY . /var/www/html

# Configure as permissões
RUN chown -R www-data:www-data /var/www/html

# Exponha a porta 80
EXPOSE 80



# Comando para iniciar o Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
