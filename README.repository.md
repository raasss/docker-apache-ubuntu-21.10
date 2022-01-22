**Maintained by**: [raasss](https://github.com/raasss/)


# Quick reference

-	Issues can be filed at [GitHub Issues](https://github.com/raasss/docker-apache-ubuntu-21.10/issues).

-	Supported architectures are: `linux/amd64`, `linux/arm/v7`, `linux/arm64` 

-	Source of this content can be found at [README.docker.io.md](https://github.com/raasss/docker-apache-ubuntu-21.10/blob/main/README.docker.io.md)

# Introduction

FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some additional features (mostly) useful for heavy-loaded sites. ([more info](https://www.php.net/manual/en/install.fpm.php))

# Quickstart guide

Starting a Apache instance with the latest version is simple via [`docker-compose`](https://github.com/docker/compose). If you don't have docker-compose tool installed, please go [here](https://docs.docker.com/compose/install/) and follow instractions.

Example `docker-compose.yml` for `apache`:

```yaml
version: '3.7'

networks:
  private:
    driver: bridge

services:
  apache:
    image: raasss/apache-ubuntu-21.10:latest
    networks:
      - private
    ports:
      - "80"
    volumes:
      - type: bind
        source: ./htdocs
        target: /var/www/html
        read_only: true
```

In your current working directory create `docker-compose.yml` file. Create also directory `htdocs/` and populate it with some `.html` files. This will be root directory for local website development.

Run docker-compose and services should be up soon:

```console
$ docker-compose up -d
```

We can find port where apache listen for connections like this:

```console
$ docker-compose port apache 80
0.0.0.0:49154
```

In this example we can go to web browser and type in url like `http://0.0.0.0:49154`.

# Advance guide

## Container shell access

The `docker-compose exec` command allows you to run commands inside a Docker container.

The following command line will give you a bash shell inside your `apache` container as root:

```console
$ docker-compose exec apache bash
```

## Access logs

The log is available through Docker's container log:

```console
$ docker-compose logs apache -f
```

You can omit `-f` if you don't want to tail logs in realtime.

## Customizing via environment variables

As most common usage of Apache is as PHP Fast-CGI proxy, following environment variables are supported.

### `PHP_FPM_SERVER`

Hostname where PHP-FPM listens to. Default value is `php-fpm-server`.

### `PHP_FPM_PORT`

Port where PHP-FPM listens to. Default value is `9000`.

### `PHP_FPM_PING_URL`

URL path where PHP-FPM ping is. Default value is `/ping`.

### `PHP_FPM_STATUS_URL`

URL path where PHP-FPM status is. Default value is `/status`.
