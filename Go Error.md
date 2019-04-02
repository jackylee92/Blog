# Go Error

## 安装扩展时报错

* go get github.com/PuerkitoBio/goquery 报错：	unrecognized import path "golang.org/x/net/html"

> 无法获取到，被墙了

````
可以从github上拿到然后copy进去
git clone https://github.com/golang/net
也可手动下载后解压
在gopath目录的src文件夹内建立如下目录 golang.org/x/net，将上面下载的net里面的文件放到该net目录中即可！
````