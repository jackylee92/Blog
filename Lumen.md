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

* 为路由指派中间件,``'middleware' => ['token']``中token对应``App\Http\Middleware\TokenMiddleware``文件

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
