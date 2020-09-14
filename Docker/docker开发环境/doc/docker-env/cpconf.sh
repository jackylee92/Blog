#! /bin/bash
docker cp 8968f2088de7:/usr/local/etc/php/php.ini-development          /d/docker-env/conf/php/phpconf/
docker cp 8968f2088de7:/usr/local/etc/php/php.ini-production         /d/docker-env/conf/php/phpconf/
docker cp 8968f2088de7:/usr/local/etc/php/conf.d        /d/docker-env/conf/php/phpconf/
docker cp 8968f2088de7:/usr/local/etc/php-fpm.conf /d/docker-env/conf/php/fpmconf/php-fpm.conf
docker cp 8968f2088de7:/usr/local/etc/php-fpm.d    /d/docker-env/conf/php/fpmconf