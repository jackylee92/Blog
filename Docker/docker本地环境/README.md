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

   或直接拉取阿里云个人景象

   ```shell
   docker pull registry.cn-hangzhou.aliyuncs.com/lijundong/nginx:v1
   docker pull registry.cn-hangzhou.aliyuncs.com/lijundong/php:v1
   docker pull registry.cn-hangzhou.aliyuncs.com/lijundong/go:v1
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
   
5. 修改``docker-compose.yml`` 实际使用的景象

6. 启动

   ```shell
   ./run.sh
   ```

7. 快速进入景象，添加命令别名

   ```shell
   dockergo=" docker exec -it go /bin/bash"
   dockerphp=" docker exec -it php /bin/sh"
   ```

### 说明

Go和PHP景象中/local/Code对应的代码目录；

tarsp是Go和PHP通用打包命令，打好的包会存放在/local/Package中也是宿主机中建立的Package中；