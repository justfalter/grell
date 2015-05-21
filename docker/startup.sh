#!/bin/bash
set -e

mkdir -p /var/cache/grell
chown -R grell:grell /var/cache/grell
rm -f /app/tmp
ln -vsf /var/cache/grell /app/tmp

echo Preparing superivosrd...
rm -vfr /etc/supervisor/conf.d/*

if [ "$1" = "start" ]; then
  ln -vsf /docker/etc/supervisor/conf.d/grell-prod.conf /etc/supervisor/conf.d/grell-prod.conf
  exec supervisord -n
fi

if [ "$1" = "start-dev" ]; then
  ln -vsf /docker/etc/supervisor/conf.d/grell-dev.conf /etc/supervisor/conf.d/grell-dev.conf
  exec supervisord -n
fi

echo "Running: $@"
exec "$@"
