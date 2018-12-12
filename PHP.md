# PHP

## 零碎

* curl

````
function curlPost($url, $data = []){
    $url = str_replace(' ','+',$url);
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "$url");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch,CURLOPT_TIMEOUT,3);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
````

* Ajax

````
$.ajax({
	url:'http://www.baidu.com',
	data:{name:'123'},
	type:'post',
	success:function(result){
		var data = eval('('+result+')');
		if(!data['res']){
			layer.msg(data['msg'],{time:2000,icon: 5});
			return false;
		}
	}
})
````

## json_encode 大括号、中括号规则

当array是一个从0开始的连续数组时，json_encode出来的结果是一个由[]括起来的字符串。

而当array是不从0开始或者不连续的数组时，json_encode出来的结果是一个由{}括起来的key-value模式的字符串。

当字符串为[1,1,1] 这种模式时，json_decode默认解析出来的结果是一个数组。

当字符串为{"1":1,"2":1} 这种模式时，json_decode默认解析出来的结果是一个对象，此时可以设置它的第二个参数为true强制让它返回数组。

## 依赖注入

将类所依赖的类通过变量注入到类内部

`````
class Superman
{
    protected $power;

    public function __construct(array $modules)
    {
        // 初始化工厂
        $factory = new SuperModuleFactory;

        // 通过工厂提供的方法制造需要的模块
        foreach ($modules as $moduleName => $moduleOptions) {
            $this->power[] = $factory->makeModule($moduleName, $moduleOptions);
        }
    }
}
class SuperModuleFactory
{
    public function makeModule($moduleName, $options)
    {
        switch ($moduleName) {
            case 'Fight': 
                return new Fight($options[0], $options[1]);
            case 'Force': 
                return new Force($options[0]);
            case 'Shot': 
                return new Shot($options[0], $options[1], $options[2]);
        }
    }
}

// 创建超人
$superman = new Superman([
    'Fight' => [9, 100],
    'Shot' => [99, 50, 2]
]);
`````

> Superman依赖的类声明的代码写到SuperModuleFactory中，

### 定义interface规定依赖类

规定依赖类：

````
interface SuperModuleInterface
{
    /**
     * 超能力激活方法
     *
     * 任何一个超能力都得有该方法，并拥有一个参数
     *@param array $target 针对目标，可以是一个或多个，自己或他人
     */
    public function activate(array $target);
}
````

实现类实现接口类方法

````
**
 * X-超能量
 */
class XPower implements SuperModuleInterface
{
    public function activate(array $target)
    {
        // 这只是个例子。。具体自行脑补
    }
}

/**
 * 终极炸弹 （就这么俗）
 */
class UltraBomb implements SuperModuleInterface
{
    public function activate(array $target)
    {
        // 这只是个例子。。具体自行脑补
    }
}
````

依赖类必须实现了接口类

````
class Superman
{
    protected $module;

    public function __construct(SuperModuleInterface $module)
    {
        $this->module = $module;
    }
}
````

使用：实例化一个依赖类，依赖类实现了接口类的方法，将依赖类作为实例化主类的参数，主类中调用依赖类中实现的方法；

````
// 超能力模组
$superModule = new XPower;
// 初始化一个超人，并注入一个超能力模组依赖
$superMan = new Superman($superModule);
````

## IOC

* 创建一个容器    
  * binds：变量=>方法体
  * $instances
  * function bind(\$abstract,\$concrete) 将方法存入\$binds中 ,\$abstract为key，表示方法体对应变量，\$concrete为value，表示方法体

````
class Container
{
    protected $binds;

    protected $instances;

    public function bind($abstract, $concrete)
    {
        if ($concrete instanceof Closure) {
            $this->binds[$abstract] = $concrete;
        } else {
            $this->instances[$abstract] = $concrete;
        }
    }

    public function make($abstract, $parameters = [])
    {
        if (isset($this->instances[$abstract])) {
            return $this->instances[$abstract];
        }

        array_unshift($parameters, $this);

        return call_user_func_array($this->binds[$abstract], $parameters);
    }
}
````

````
// 创建一个容器（后面称作超级工厂）
$container = new Container;

// 向该 超级工厂添加超人的生产脚本
$container->bind('superman', function($container, $moduleName) {
    return new Superman($container->make($moduleName));
});

// 向该 超级工厂添加超能力模组的生产脚本
$container->bind('xpower', function($container) {
    return new XPower;
});

// 同上
$container->bind('ultrabomb', function($container) {
    return new UltraBomb;
});

// ****************** 华丽丽的分割线 **********************
// 开始启动生产
$superman_1 = $container->make('superman', 'xpower');
$superman_2 = $container->make('superman', 'ultrabomb');
$superman_3 = $container->make('superman', 'xpower');
````

__个人理解__

依赖注入

> 定义Container 类，该类中有一个static \$binds;静态数组变量，该变量key为类名，value为方法体(方法体一般为返回这个key的类的实例)；一个static function bind(\$abstract,\$concrete) 方法，将类和方法注入到Container的$binds中，一个static function make(\$abstract)方法，该方法主要是创建实例调用\$binds中\$abstract的方法体，创建实例；然后可以使用该实例调用实例的类的方法；



### 函数

* iterator_to_array — 将迭代器中的元素拷贝到数组