# TarsGo

## 安装

## 使用

__go需要1.9以上版本__

### HTTP：

1. 新建项目文件夹、src、bin、pkg

   ````
   makedir Test
   cd Test
   mkdir src bin pkg
   ````

2. 将GOPATH指向该项目目录

   ````
   vim ~/.base_profile
   添加或修改已存在的GOPATH=项目根目录
   source ~/.base_profile
   ````

3. clone下TarsGo

   ````
   cd $GOPATH
   go get github.com/TarsCloud/TarsGo/tars
   ````

   此时会在src中生成github.com目录，其中包含了相关工具

   生产工具'tars2go'

   ````
   cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go && go build .
   ````

   移动工具到项目bin中

   ````
   cp tars2go $GOPATH/bin
   ````

4. 生成项目

   > Tars 实例的名称，有三个层级，分别是 App（应用）、Server（服务）、Servant（服务者，有时也称 Object）三级

   Tars go 提供端生成工具create_tars_server.sh，也可以使用其生成http代码

   ````
   cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools
   ./create_tars_server.sh Test Server Obj
   ````

   此时在项目根目录下src中会生成Test/Server目录，删除目录中Http使用不到的``.tars``、`` client``、``debugtool``

   修改makefile 去除下列代码

   ````
   CONFIG := client
   ````

   修改Server.go文件

   __注意AddHttpServant()中的内容__

   ````
   package main
   
   import (
   	"github.com/TarsCloud/TarsGo/tars"
   )
   
   func main() {
   	mux := &tars.TarsHttpMux{}
   	mux.HandleFunc("/", HttpRootHandler)
   	cfg := tars.GetServerConfig()
   	tars.AddHttpServant(mux, cfg.App+"."+cfg.Server+".Obj") //Register http server
   	tars.Run()
   }
   ````

   修改ObjImp.go

   ````
   package main
   
   import (
   	"fmt"
     "time"
   	"net/http"
   )
   
   func HttpRootHandler(w http.ResponseWriter, r *http.Request) {
       time_fmt := "2006-01-02 15:04:05"
       local_time := time.Now().Local()
       time_str = local_time.Format(time_fmt)
       ret_str = fmt.Sprintf("{\"msg\":\"Hello, Tars-Go!\", \"time\":\"%s\"}", time_str)
   
   	w.Header().Set("Content-Type", "application/json;charset=utf-8")
   	w.Write([]byte(ret_str))
   	return
   }
   ````

5. 打包发布

   ```js
   # 打包
   cd $GOPATH/src/Test/Server
   make && make tar
   ```

   发布：

   - 应用：`Test`
   - 服务名称：`Server`
   - 服务类型：`tars_go或tars_cpp`
   - 模板：`tars.default`
   - 节点：填写你打算部署的 IP 地址
   - OBJ：`Obj`
   - 端口类型：`TCP`
   - 协议：`非TARS`
   - 端口可以自定义，也可以填好信息后点 “获取端口” 来生成。

6. 测试：

   ````
   curl ip:端口
   return ： {"msg":"Hello, Tars-Go!", "time":"2019-06-12 16:05:36"}
   ````

### 服务端：

## ERROR

* ``make tar``打包失败

````
make: *** 没有规则可以创建目标“tar”。 停止
````

> 重新安装go，可能go环境错误

