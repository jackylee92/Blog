# Docker

__安装__

* 自带的yum中有一个很老版本的docker包，需要先删除

````
yum -y remove docker docker-common container-selinux
````

* 配置新的静项源地址

````
yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
````

* 更新静项源

````
yum makecache fast
````

* 安装最稳定版本

````
yum -y install docker-engine
或
yum install docker-ce
````

* 或者查看其他版本并安装

````
yum list docker-engine.x86_64  --showduplicates |sort -r

docker-engine.x86_64  1.13.0-1.el7                               docker-main
docker-engine.x86_64  1.12.5-1.el7                               docker-main   
docker-engine.x86_64  1.12.4-1.el7                               docker-main   
docker-engine.x86_64  1.12.3-1.el7                               docker-main  
yum -y install docker-engine-<VERSION_STRING> 
````

* 测试

````
docker run hello-world
````

__使用__

每一个docker只可以运行一个指定的程序

> docker run --name -it centos /bin/bash 表示启动/bin/bash这个命令

* 查看镜像

````
docker images
````

* 删除镜像

````
docker rmi 镜像名称
````

* 查看运行的docker

````
docker ps
````

* 查看命令记录

````
docker ps -a
````

* 运行记录

````
# docker run -p 宿机端口:镜像内端口 镜像
 docker run -p 8080:80 -d daocloud.io/nginx
````

* 删除运行的记录

````
docker rm 记录名
````

* 保存image生成新的image

````
# docker commit -m "提交备注" 运行的dockerID 保存设置的image名
docker commit -m "add" 121212323 name
````

* 将文件转移至docker中

````
# docker cp 文件 镜像启动后的ID://镜像中的目录
docker cp index.html 1231231://use/share/nginx/html/
````

* 停止docker静项源运行

````
# docker stop 镜像源运行的id
docker stop 1231231
````