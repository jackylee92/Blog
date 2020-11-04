#! /bin/bash
# 代码
# go代码：....../Golang
# php代码：....../PHP
# 打包文件：....../Package
export DOCKER_CODEDIR=/Users/adong/Dev
# 日志
export DOCKER_LOGDIR=`pwd`/logs
# 配置文件
export DOCKER_CONFDIR=`pwd`/conf

# 需要建立docker网络
docker-compose -f docker-compose.yml up -d
