#! /bin/bash
docker cp 8968f2088de7:/usr/local/etc/php/php.ini-development ~/Dev/Docker
docker cp 8968f2088de7:/usr/local/etc/php/php.ini-production ~/Dev/Docker
docker cp 8968f2088de7:/usr/local/etc/php/conf.d ~/Dev/Docker
docker cp 8968f2088de7:/usr/local/etc/php-fpm.conf ~/Dev/Docker
docker cp 8968f2088de7:/usr/local/etc/php-fpm.d ~/Dev/Docker
