#! /bin/bash
# 代码
export DOCKER_CODEDIR=/Users/adong/Dev
# 日志
export DOCKER_LOGDIR=/Users/adong/Dev/Docker/job/logs
# 配置文件
export DOCKER_CONFDIR=/Users/adong/Dev/Docker/job/conf

# 需要建立docker网络
docker-compose -f docker-compose.yml up -d
