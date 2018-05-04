### Lumen

---

__路由配置__

* 在routes/中添加配置
  
````
$router->group([ 'namespace' => 'Api', 'prefix' => 'api','middleware' => ['token'] ],function($app) {
    $app->get('test', 'TestController@index');
    $app->post('auth', 'TestController@auth');
});
````
* namespace => [路径app/Http/Controller/Api]
* prefix => 统一前缀 www.xxx.com/prefix/xxx
* middleware => ['中间件']
* $app->请求方式('action','controllerName@functionName') => 请求方法 www.xxx.com/prefix/action 访问的是controllerName下的functionName方法
* ![目录](https://github.com/jackylee92/Blog/blob/master/Images/Snip20180417_1.png?raw=true)
* ``bootstrap/app``中定义了路由使用的文件
  *
  
   ````
	$app->router->group([
   		'namespace' => 'App\Http\Controllers',
	], function ($router) {
   		require __DIR__.'/../routes/web.php';
	});
	````

----

__中间件__

* 指定启用中间件 ``'middleware' => ['token']``

````
$router->group([ 'namespace' => 'Api', 'prefix' => 'api','middleware' => ['token'] ],function($app) {
//$router->group([ 'namespace' => 'Api', 'prefix' => 'api' ],function($app) {
    $app->get('test', 'TestController@index');
    $app->post('auth', 'TestController@auth');
});
````

* 为路由指派中间件``bootstrap\app.php``中``'middleware' => ['token']``中token对应``App\Http\Middleware\TokenMiddleware``文件

````
$app->routeMiddleware([
    'token' => App\Http\Middleware\TokenMiddleware::class
]);
````
* 定义中间件规则过滤http请求 在``App\Http\Middleware\`` 创建TokenMiddleware.php 代码实例如下：必须有handle方法 参数固定

````
class TokenMiddleware
{
    /**
     * 运行请求过滤器。
     * 
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        ... //处理条件

        return $next($request); //如此返回格式，才可将请求参数传递到程序更深处
    }

}
````

__配置文件__

* 在``vendor\larvel\lumen-framework``中config文件夹复制到根目录中
* 配置启用config文件,例如config中有一个app.php配置文件。则在``bootstrap.app.php``中添加``$app->configure('app');``即可；
* 在任何地方都可使用``config('app.key');``,``app => 配置文件名``,'key => 配置参数的key'``

__自定义公共函数__

* 在``app``中添加``Common\function.php`` 这当中写入公共函数；
* 在根目录composer.json中添加自动加载
  *

  ````
    "autoload": {
        "psr-4": {
            "App\\": "app/"
        },
        "files": [
            "app/Common/function.php"
        ]
    },
  ````
* 根目录执行 ``composer dump-autoload -o`` 
* 在控制器中即可使用

__本地化 自定义语言包__

* 在``resources/lang/zh_cn``中添加自己的语言包文件 没有目录则创建目录和文件
  ````
  //语言包内容如下
  
  <?php
  return [
  		100 => [‘en’=>'success','zh'=>'请求成功'],
  		400 => [‘en’=>'fail','zh'=>'请求失败'] 
  ];
  ?>
  ````
* 在config.php 没有则添加 有则修改 ``'locale' => env('APP_LOCALE', 'zh_cn'),``;
* 在项目中使用辅助函数``trans('文件名.配置项')`` 返回的为当前配置项为key的value；