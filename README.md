# Laravel 10 with Docker + Nginx + PGSQL + PHP 8.3

## Install and Cofniguration

### First copy the .env.example file to .env and configure the database settings:

```bash
cp .env.example .env
```

### Run the following commands to build the project:

```bash
docker compose up -d --build --force-recreate --remove-orphans
```

### Run the following commands to install the dependencies:

```bash
docker exec -it base-app bash
composer install
php artisan migrate --seed 
```

### Generate the application key:

```bash
php artisan key:generate
```

### Access the application at the following address:

```bash
http://localhost:8443
```


