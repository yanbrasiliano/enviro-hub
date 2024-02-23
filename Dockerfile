FROM php:8.3-fpm as base

# Definindo variáveis de ambiente
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV ACCEPT_EULA=Y
ENV DEBIAN_FRONTEND=noninteractive
ARG user=www-data
ARG uid=1000

# Definindo o diretório de trabalho
WORKDIR /var/www/html

# Criando e configurando o usuário
RUN usermod -u $uid $user \
  && mkdir -p /home/$user/.composer \
  && chown -R $user:$user /var/www/html \
  && chown -R $user:$user /home/$user

# Instalando dependências
RUN apt-get update && apt-get install -y \
  nginx \
  libpq-dev \
  libzip-dev \
  htop \
  vim \
  cron \
  supervisor \
  git \
  libwebp-dev \
  libpng-dev \
  libjpeg-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libgd-dev \
  jpegoptim \
  optipng \
  pngquant \
  gifsicle \
  libxml2-dev

# Instalar extensão Redis
RUN pecl install -o -f redis \
  && rm -rf /tmp/pear \
  && docker-php-ext-enable redis

# Instalando extensões do PHP
RUN docker-php-ext-configure zip
RUN docker-php-ext-configure gd --enable-gd --with-webp --with-jpeg --with-freetype
RUN docker-php-ext-install -j$(nproc) exif gd zip pdo pdo_pgsql ftp bcmath xml

# Instalando Xdebug
RUN pecl install xdebug \
  && docker-php-ext-enable xdebug

# Configurações do Xdebug (ajuste conforme necessário)
RUN echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Configurando o Supervisor
RUN mkdir -p /var/log/supervisor
COPY ./docker/SUPERVISOR/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configurações adicionais do PHP
RUN printf 'upload_max_filesize = 16M \npost_max_size = 64M\n' > /usr/local/etc/php/conf.d/uploads.ini
RUN printf '%s\n%s\n' "max_execution_time = -1" "memory_limit = -1" > /usr/local/etc/php/conf.d/memory.ini
RUN printf '[PHP]\ndate.timezone = "America/Bahia"\n' > /usr/local/etc/php/conf.d/tzone.ini

# Instalando Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalando Node.js
COPY --from=node:18 /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:18 /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Instalando dependências do Node.js
RUN npm install -g npx yarn gulp-cli cross-env node-sass sass postcss-cli autoprefixer 
RUN git config --global --add safe.directory /var/www/html

# Configuração do NGINX
COPY ./docker/NGINX/default.conf /etc/nginx/sites-available/default
RUN if [ -e /etc/nginx/sites-enabled/default ]; then rm /etc/nginx/sites-enabled/default; fi && \
  ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Copiando arquivos para o container
COPY --chown=www-data:www-data . .

# Permissões
RUN chmod +x ./permissions.sh \
  && ./permissions.sh

# Comando para iniciar o Supervisor
CMD ["supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
