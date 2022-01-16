FROM ubuntu:20.04

ENV PHP_FPM_SERVER php-fpm-server
ENV PHP_FPM_PORT 9000
ENV PHP_FPM_PING_URL /ping
ENV PHP_FPM_STATUS_URL /status

RUN set -e; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y --no-install-recommends \
        tini \
        apache2-bin \
        apache2-data \
        apache2-utils \
        apache2; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rvf /var/lib/apt/lists/*

RUN set -e; \
    cd /var/log; \
    rm -rvf apache2; \
    mkdir -v -m 0750 apache2; \
    chown -v root:adm apache2; \
    cd apache2; \
    ln -s /dev/stdout access.log; \
    ln -s /dev/stdout other_vhosts_access.log; \
    ln -s /dev/stderr error.log

COPY servername.conf /etc/apache2/conf-available/servername.conf
RUN set -e; \
    a2enmod mpm_event ssl rewrite proxy proxy_http proxy_fcgi; \
    a2enconf servername

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN set -e; \
    chmod -v 0644 /etc/apache2/sites-available/000-default.conf; \
    chown -v root:root /etc/apache2/sites-available/000-default.conf

VOLUME [ "/var/www/html" ]

EXPOSE 80
EXPOSE 443

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 0755 /docker-entrypoint.sh

ENTRYPOINT ["tini", "--"]
CMD ["/docker-entrypoint.sh"]
