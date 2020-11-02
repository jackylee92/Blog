# 建立docker的本地环境

## 使用

1. 安装Docker

2. 进入dockerFile构建php、go、nginx景象

   ```shell
   cd golang
   docker build -t dev/go:v1 .
   cd ../php
   docker build -t dev/php:v1 .
   cd ../nginx
   docker build -t dev/nginx:v1 .
   ```

3. 配置代码目录

   DOCKER_CODEDIR下面建立PHP、Golang、Package目录

   > __PHP：__ 放置所有PHP项目代码
   >
   > __Goalng：__ 放置所有Golang项目代码
   >
   > __Package：__ tars打包后存放包文件地址

4. 创建docker网络

   ```shell
   docker network create docker
   ```
   
5. 启动

   ```shell
   ./run.sh
   ```

   