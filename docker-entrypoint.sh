# !/usr/bin/env bash

set -ex

rm -rvf /var/run/apache2/apache2.pid

exec /usr/sbin/apachectl -DFOREGROUND
