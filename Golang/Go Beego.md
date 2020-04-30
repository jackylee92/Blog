# Go Beego

__安装__

* go环境配置

````
vim /etc/profile
export GOROOT=/usr/go # 安装目录
export PATH=$GOROOT/bin:$PATH
export GOPATH=/home/jacky/mac/Project/go/project # 项目目录
````

* 下载安装beego

````
// 进入project目录
go get github.com/astaxie/beego
````

* 下载安装bee

````
//进入project目录
go get github.com/beego/bee
````

* 创建项目

````
//进入project目录
bee new hello
````

* 运行

````
//进入project/src/hello
bee run
````