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

1. 使用tars2go生成tars服务代码

   ````
   $GOPATH/bin/tars2go -outdir=../vendor/tars ./global.tars
   ````

   > 生成的代码在指定的路径中，http服务和tcp服务生成代码文件相同，所以如果所有的服务使用的tars文件相同，则只需要生成一份即可;
   >
   > 本人在项目中使用到的tars文件如下，所有项目使用同一套；
   >
   > http端调用任何服务都可以使用此服务生成的tars代码，通过制定服务名称来判断调用的服务
   >
   > tcp端依赖的tars文件代码也是同一套，需要在main函数中使用服务端特有的写法和makefile文件中的配置对应的tars平台的配置为服务端配置，即可制定该服务为tcp服务，提供方法有Get、Put

   global.tars

   ````
   module Server
   {
       interface Server
       {
           int Get(string param, out string data);
   
           int Put(string param, out string data);
       };
   };
   ````

   Main.go

   ````
   package main
   
   import (
   	"github.com/TarsCloud/TarsGo/tars"
   	"tars/Server" //tars2go生成的服务代码
   )
   type Imp struct { // 定义一个要实现Get/Put方法的的接结构体
   }
   
   // 实现Get方法，注意参数需要和tars文件中对应
   func (imp *Imp) Get(Param string, Data *string) (int32, error) {
   	data := "测试GetGet [" + Param + "]"
   	Data = &data
   	return 100, nil
   }
   
   // 实现Put方法，注意参数需要和tars文件中对应
   func (imp *Imp) Put(Param string, Data *string) (int32, error) {
   	data := "测试PutPut [" + Param + "]"
   	Data = &data
   	return 101, nil
   }
   
   // mian函数写法 注意Imp、Server.Server、tarsObj需要和tars平台的配置中相同
   func main() { 
   	imp := new(Imp)                                        //New Imp
   	app := new(Server.Server)                              //New init the A Tars
   	cfg := tars.GetServerConfig()                          //Get Config File Object
   	app.AddServant(imp, cfg.App+"."+cfg.Server+".tarsObj") //Register Servant
   	tars.Run()
   }
   
   ````

   

2. 建立mkefile文件，这个文件很重要，打包必须！其中配有服务名相关

   ````
   APP       := pkg
   TARGET    := serverName
   MFLAGS    :=
   DFLAGS    :=
   CONFIG    :=
   STRIP_FLAG:= N
   J2GO_FLAG:= 
   
   libpath=${subst :, ,$(GOPATH)}
   $(foreach path,$(libpath),$(eval -include $(path)/src/github.com/TarsCloud/TarsGo/tars/makefile.tars))
   ````

   

## ERROR

* ``make tar``打包失败

````
make: *** 没有规则可以创建目标“tar”。 停止
````

> 重新安装go，可能go环境错误

