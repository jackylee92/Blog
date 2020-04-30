# PHPUnit单元测试

什么场景让我试用单元测试

> 服务化后单个服务需要打包上传到服务平台，通过访问接口方法测试的方式太繁琐，时间太长；所以需要本地跑单元测试可以快速测试，调试接口；

## 安装

Linux安装phpunit.phar

下载（可以根据当前环境的PHP版本选择对应的下载，我的是php7.28）

````
wget http://phar.phpunit.cn/phpunit-6.2.phar
chmod +x phpunit-6.2.phar
mv phpunit-6.2.phar /usr/local/bin/phpunit
phpunit --version
````

输出：

>PHPUnit 6.2.4 by Sebastian Bergmann and contributors.

## 使用

项目中下载扩展

````
composer require --dev phpunit/phpunit ^6.2
````

配置xml文件，简单的配置下

````xml
<phpunit bootstrap="vendor/autoload.php">
    <testsuites>
        <testsuite name="src">
            <directory>test</directory>
        </testsuite>
    </testsuites>
	<filter>
        <whitelist addUncoveredFilesFromWhitelist="true" processUncoveredFilesFromWhitelist="true">
            <directory suffix=".php">./test/</directory>
        </whitelist>
    </filter>
</phpunit>
````

* bootstrap：依赖，用于指定测试运行前需要引入的文件，这里配置为 `vendor/autoload.php` 表示会引入 Composer 自动加载和管理的所有依赖，以便在测试文件中使用
* directory：测试文件所在的目录
* suffix：测试范围覆盖.php结尾的文件
* testsuite name="src"：命名空间

代码：

在项目目录中建立test目录，test中建立testIndex.php

> 文件名需要以test打头 .php结尾，test目录名为xml配置中指定的

````
<?php
declare(strict_types=1);

namespace src\test;
use PHPUnit\Framework\TestCase;
use src\service\resource\Resource;

/**
 * @covers Email
 */
final class IndexTest extends TestCase
{
    public function testIndex(): void
    {
        $service = new Resource('test_unique');
        $res = $service->testA();
        var_dump($res);
    }
}
````

启动：

````
phpunit test/testIndex.php
````

## Tars中使用

> tars客户端在调用服务端时有两种方式

* 通过主控

````
$config = new \Tars\client\CommunicatorConfig();
//指定主控地址
$config->setLocator('tars.tarsregistry.QueryObj@tcp -h 172.16.0.161 -p 17890');
// 设置服务参数
$config->setModuleName('App.Server');
$config->setCharsetName('UTF-8');
// 实例化服务，传入主控参数
$servant = new \PHPTest\PHPServer\obj\TestTafServiceServant($config);
$name = 'ted';
// 调用方法
$intVal = $servant->sayHelloWorld($name, $greetings);
var_dump($greetings);
````

* 指定服务地址

````
// 服务地址和IP
$route['sIp'] = '172.16.0.161';
$route['iPort'] = 28888;
$routeInfo[] = $route;
$config = new \Tars\client\CommunicatorConfig();
$config->setRouteInfo($routeInfo);
$config->setSocketMode(2); //1标识socket 2标识swoole同步 3标识swoole协程
$config->setModuleName('App.Server');
$config->setCharsetName('UTF-8');

// 实例化服务传入服务地址参数
$servant = new \PHPTest\PHPServer\obj\TestTafServiceServant($config);
$name = 'ted';
// 调用方法
$intVal = $servant->sayHelloWorld($name, $greetings);
var_dump($greetings);
````

调用服务内置方法在 phptars/tars-client/src/Communicator.php中83行 invoke 方法中

方法156行：

````
            if(!is_null($this->_locator))
            {
                $this->_statF->addStat($requestPacket->_servantName, $requestPacket->_funcName, $ip,
                    $port, ($endTime - $startTime), 0, 0);
            }

            return $sBuffer;
````

``$this->_statF``对象在server.php中start()方法中实例化，此处是起到上报作用，也就是说如果不启动服务就不会实例化$this->_statF对象，就会是null这个地方就会报错；__所以将return部分移到前面 __单元测试时不触发上报功能；在配置中加上debug，当debug为true时代表单元测试，不启动上报，修改后代码如下：

````
    // 同步的socket tcp收发
    public function invoke(RequestPacket $requestPacket, $timeout, $responsePacket = null, $sIp = '', $iPort = 0)
    {
        // 转换成网络需要的timeout
        $timeout = $timeout / 1000;

        $startTime = $this->militime();
        $count = count($this->_routeInfo) - 1;
        if ($count === -1) {
            throw new \Exception('Rout fail', Code::ROUTE_FAIL);
        }
        $index = rand(0, $count);
        $ip = empty($sIp) ? $this->_routeInfo[$index]['sIp'] : $sIp;
        $port = empty($iPort) ? $this->_routeInfo[$index]['iPort'] : $iPort;
        $bTcp = isset($this->_routeInfo[$index]['bTcp']) ?
            $this->_routeInfo[$index]['bTcp'] : 1;
        if(ENVConf::$debug) {
            $ip = ENVConf::$tarsIp;
        }

        try {
            $requestBuf = $requestPacket->encode();
            $responseBuf = '';
            if ($bTcp) {
                switch ($this->_socketMode) {
                    // 单纯的socket
                    case 1:{
                        $responseBuf = $this->socketTcp($ip, $port,
                            $requestBuf, $timeout);
                        break;
                    }
                    case 2:{
                        $responseBuf = $this->swooleTcp($ip, $port,
                            $requestBuf, $timeout);
                        break;
                    }
                    case 3:{
                        $responseBuf = $this->swooleCoroutineTcp($ip, $port,
                            $requestBuf, $timeout);
                        break;
                    }
                    case 4:{
                        $responseBuf = $this->swoolGrpc($ip, $port, $requestBuf, $timeout, $requestPacket->getPath());
                        break;
                    }
                }
            } else {
                switch ($this->_socketMode) {
                    // 单纯的socket
                    case 1:{
                        $responseBuf = $this->socketUdp($ip, $port, $requestBuf, $timeout);
                        break;
                    }
                    case 2:{
                        $responseBuf = $this->swooleUdp($ip, $port, $requestBuf, $timeout);
                        break;
                    }
                    case 3:{
                        $responseBuf = $this->swooleCoroutineUdp($ip, $port, $requestBuf, $timeout);
                        break;
                    }
                }
            }

            $responsePacket = $responsePacket ? $responsePacket : new ResponsePacket();
            $responsePacket->_responseBuf = $responseBuf;
            $responsePacket->iVersion = $this->_iVersion;
            $sBuffer = $responsePacket->decode();

            $endTime = $this->militime();
            if(ENVConf::$debug) {
                return $sBuffer;
            }

            if(!is_null($this->_locator))
            {
                $this->_statF->addStat($requestPacket->_servantName, $requestPacket->_funcName, $ip,
                    $port, ($endTime - $startTime), 0, 0);
            }

            return $sBuffer;
        } catch (\Exception $e) {
            $endTime = $this->militime();

            if(!is_null($this->_locator))
            {
                $this->_statF->addStat($requestPacket->_servantName, $requestPacket->_funcName, $ip,
                    $port, ($endTime - $startTime), $e->getCode(), $e->getCode());
            }
            throw $e;
        }
    }
````

ENVConf.php 如下：

````
    public static $tarsIp = '1.1.1.1';
    public static $socketMode = 3;
    public static $socketModuleName = 'api.bbyj';

    public static function locator()
    {
        return 'tars.tarsregistry.QueryObj@tcp -h '.self::$tarsIp.' -p 17890';

    }
    public static $debug = true;
````

