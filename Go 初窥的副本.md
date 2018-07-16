# Go 初窥

__安装__

* 下载

````
https://golang.org/dl/
````
* 移动、解压

````
mv go1.9.5.linux-amd64.tar.gz /usr/

cd /usr

tar -zxvf go1.9.5.linux-amd64.tar.gz

//多了一个go文件夹
````

* 环境变量

vim /etc/profile

````
export GOROOT=/usr/go //安装目录

export PATH=$GOROOT/bin:$PATH

export GOPATH=/home/jacky/mac/Project/go //项目目录

````

````
source /etc/profile
````

* 测试
helloworld
````
package main

import "fmt"

func main() {
        fmt.Println("123")
}

````

````
go run 
````

__命令__

* 编译运行

````
go run
````

* 检查代码

````
go vet
````

* 格式化代码

````
go fmt
````

* 编译

````
go build
````