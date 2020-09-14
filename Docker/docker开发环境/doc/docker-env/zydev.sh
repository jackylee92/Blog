#! /bin/bash
export CODEDIR=/d/code
export LOGDIR=/d/log
export DOCKER_NGINX_CONFDIR=/d/docker-env/conf
export DOCKER_NGINX_LOGDIR=/d/docker-env/logs
export SYSTEM_CONFDIR=/d/code/Config/tars

docker-compose -f docker-compose.yml up -d