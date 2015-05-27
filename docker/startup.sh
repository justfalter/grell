#!/bin/bash
set -e

mkdir -p /var/cache/grell
chown -R grell:grell /var/cache/grell
rm -f /app/tmp
ln -vsf /var/cache/grell /app/tmp

echo Preparing superivosrd...
rm -vfr /etc/supervisor/conf.d/*
ln -vsf /docker/etc/supervisor/conf.d/grell.conf /etc/supervisor/conf.d/grell.conf

echo Preparing nginx...
rm -vfr /etc/nginx/sites-enabled/*
ln -vsf /docker/etc/nginx/sites-enabled/grell.conf /etc/nginx/sites-enabled/grell.conf
cp -vf /docker/etc/nginx/nginx.conf /etc/nginx/nginx.conf

if [ "$1" = "start" ]; then
  exec supervisord -n
fi

echo "Running: $@"
exec "$@"
