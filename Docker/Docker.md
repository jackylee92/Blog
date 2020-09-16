# Docker

## 安装

* 自带的yum中有一个很老版本的docker包，需要先删除

  ```shell
  yum -y remove docker docker-common container-selinux
  ```

* 配置新的静项源地址

  ```shell
  yum install -y yum-utils device-mapper-persistent-data lvm2
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  ```

* 更新静项源

  ```shell
  yum makecache fast
  ```

* 安装最稳定版本

  ```shell
  yum -y install docker-engine
  # 或
  yum install docker-ce
  ```

* 或者查看其他版本并安装

  ```shell
  yum list docker-engine.x86_64  --showduplicates |sort -r
  
  docker-engine.x86_64  1.13.0-1.el7                               docker-main
  docker-engine.x86_64  1.12.5-1.el7                               docker-main   
  docker-engine.x86_64  1.12.4-1.el7                               docker-main   
  docker-engine.x86_64  1.12.3-1.el7                               docker-main  
  yum -y install docker-engine-<VERSION_STRING> 
  ```

* 测试

  ```shell
  docker run hello-world
  ```

## 使用

[菜鸟教程](https://www.runoob.com/docker/docker-ps-command.html)

* 查看镜像

  ```shell
  docker images
  ```

* 删除镜像

  ```shell
  docker rmi 镜像名称
  ```

* 查看运行的docker

  ```shell
  docker ps
  ```

* 查看所有的容器，包括未运行的

  ```shell
  docker ps -a
  ```

* 运行记录

  ```shell
  # docker run -p 宿机端口:镜像内端口 镜像
  docker run -p 8080:80 -d daocloud.io/nginx
  # 表示启动/bin/bash这个命令
  docker run --name -it centos /bin/bash
  # 使用镜像centos以交互模式启动一个容器
  docker run -it centos
  ```

* 删除运行的记录

  ```shell
  docker rm 记录名
  ```

* 保存image生成新的image

  ```shell
  # docker commit -m "提交备注" 运行的dockerID 保存设置的image名
  docker commit -m "add" 121212323 name
  ```

* 将文件转移至docker中

  ```shell
  # docker cp 文件 镜像启动后的ID://镜像中的目录
  docker cp index.html 1231231://use/share/nginx/html/
  ```

* 停止docker静项源运行

  ```shell
  # docker stop 镜像源运行的id
  docker stop 1231231
  ```

* 通过DockerFiel生成镜像

  ```shell
  docker build -t docker_name:v1.0.0 .
  ```

* none容器操作

  ```shell
  docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }') //停止容器
  docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }')  //删除容器 
  docker rmi $(docker images | grep "none" | awk '{print $3}')  //删除镜像 
  ```

  

### dockerFile

* FROM：基础镜像
* MAINTAINER：维护者信息
* RUN：运行命令
* ADD：添加文件，会自动解压
* CPQY：拷贝文件
* WORKDIR：当前工作目录
* VOLUME：目录挂载
* EXPOSE：端口

## 阿里云Docker仓库

* 本地登录阿里云仓库

  ```shell
  docker login --username=$userName registry.cn-hangzhou.aliyuncs.com
  password: $password
  ```

  