# Go Beego 路由

__Web__

* routers

	在项目中routers目录下会有router.go这是用来配置路由
	
	````
	package routers

	import (
		"quickstart/controllers"
		"github.com/astaxie/beego"
	)

	func init() {
   		beego.Router("/", &controllers.MainController{})
   		//添加一个新的路由
   		beego.Router("/user", &controllers.UserController{})
	}
	````
