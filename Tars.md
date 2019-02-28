[TOC]



# Tars安装

## 介绍
Tars是基于名字服务使用Tars协议的高性能RPC开发框架，同时配套一体化的服务治理平台，帮助个人或者企业快速的以微服务的方式构建自己稳定可靠的分布式应用。

Tars是将腾讯内部使用的微服务架构TAF（Total Application Framework）多年的实践成果总结而成的开源项目。Tars这个名字来自星际穿越电影人机器人Tars， 电影中Tars有着非常友好的交互方式，任何初次接触它的人都可以轻松的和它进行交流，同时能在外太空、外星等复杂地形上，超预期的高效率的完成托付的所有任务。 拥有着类似设计理念的Tars也是一个兼顾易用性、高性能、服务治理的框架，目的是让开发更简单，聚焦业务逻辑，让运营更高效，一切尽在掌握。

目前该框架在腾讯内部，有100多个业务、1.6多万台服务器上运行使用。

## 现状
* 文档不全；
* php-tars刚开源，底层使用swoole，开发习惯需做改变；
* 跨语言调用、现有业务微服务化、编码规范、架构调整需要多实践探索；
* 使用中发现问题多反馈，争取得到Tars官方的支持！

__以下为多次安装后总结简单具体步骤__

## 环境依赖  

| 软件           | 软件要求                                         |
| -------------- | ------------------------------------------------ |
| linux内核版本: | 2.6.18及以上版本（操作系统依赖）                 |
| gcc版本:       | 4.8.2及以上版本、glibc-devel（c++语言框架依赖）  |
| bison工具版本: | 2.5及以上版本（c++语言框架依赖）                 |
| flex工具版本:  | 2.5及以上版本（c++语言框架依赖）                 |
| cmake版本：    | 2.8.8及以上版本（c++语言框架依赖）               |
| resin版本：    | 4.0.49及以上版本（web管理系统依赖）              |
| Java JDK版本： | java语言框架（最低1.6），web管理系统（最低1.8）  |
| Maven版本：    | 2.2.1及以上版本（web管理系统、java语言框架依赖） |
| mysql版本:     | 4.1.17及以上版本（框架运行依赖）                 |
| rapidjson版本: | 1.0.2版本（c++语言框架依赖）                     |

## 安装服务器环境  
###  install (提前安装好需要的扩展)  
    yum install -y gcc gcc-c++ bison flex glibc-devel ncurses-devel perl perl-Module-Install.noarch git zlib-devel ncurses-devel curl-devel autoconf zlib-devel sysstat
###  关闭selinux防火墙  (非必须)
    setenforce 0    
### 准备软件包：  
1. jdk-8u171-linux-x64.tar.gz 

2. resin-pro-4.0.56.tar.gz

3. cmake-3.6.2.tar.gz

4. mysql-5.6.25.tar.gz

5. swoole-4.0.1.tgz

6. Tars  
  `cd /opt`  
  `git clone https://github.com/TarsCloud/Tars.git`  

  ``git clone https://github.com/TarsCloud/TarsWeb.git ``

  替换tars中的ip、和mysql 的tars用户密码 

  ````
  sed -i "s/10.120.129.226/${YouIp}/g" `grep 10.120.129.226 -rl ./*`
  
  sed -i "s/db.tars.com/${YouIp}/g" `grep db.tars.com -rl ./*`
  
  sed -i "s/web.tars.com/${YouIp}/g" `grep web.tars.com -rl ./*`
  
  sed -i "s/tars2015/${MySqlPwd}/g" `grep tars2015 -rl ./*`
  
  sed -i "s/192.168.2.131/${YouIp}/g" `grep 192.168.2.131 -rl ./*`
  
  sed -i "s/web.tars.com/${YouIp}/g" `grep web.tars.com -rl ./*`
  
  sed -i "s/registry.tars.com/${YouIp}/g" `grep registry.tars.com -rl ./*`
  ````

### 安装Cmake  
`tar -zxvf cmake-3.6.2.tar.gz`  
`cd cmake-3.6.2`  
`./bootstrap`  
`make`  
`make install`  
### 安装resion（新版本已经不使用）
`tar -zxvf resin-pro-4.0.56.tar.gz`  
`cp -rf resin-pro-4.0.56 /usr/local/resin`  
### 安装mysql  
`tar -zxvf mysql-5.6.25.tar.gz`  
` cd mysql-5.6.25`  
`cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DWITH_INNOBASE_STORAGE_ENGINE=1 -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci`  
`make`  
`make install`  
`useradd mysql`  
`chown -R mysql:mysql /usr/local/mysql/`  
`cd /usr/local/mysql/`  
`cp support-files/mysql.server /etc/init.d/mysql`  
`vim /etc/my.cnf`  

    [mysqld]
    
    # Remove leading # and set to the amount of RAM for the most important data
    # cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
    innodb_buffer_pool_size = 128M
    
    # Remove leading # to turn on a very important data integrity option: logging
    # changes to the binary log between backups.
    # log_bin
    
    # These are commonly set, remove the # and set as required.
    basedir = /usr/local/mysql
    datadir = /usr/local/mysql/data
    # port = .....
    # server_id = .....
    socket = /tmp/mysql.sock
    
    bind-address=${your machine ip}
    
    # Remove leading # to set options mainly useful for reporting servers.
    # The server defaults are faster for transactions and fast SELECTs.
    # Adjust sizes as needed, experiment to find the optimal values.
    join_buffer_size = 128M
    sort_buffer_size = 2M
    read_rnd_buffer_size = 2M
    
    sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES



``perl scripts/mysql_install_db --user=mysql``

### 配置mysql

`service mysql start`  
`chkconfig mysql on`  
`vim /etc/profile`       

    PATH=$PATH:/usr/local/mysql/bin
    export PATH  

` source /etc/profile `.   

添加mysql库路径.   

``vim /etc/ld.so.conf ``    

```
/usr/local/mysql/lib/
```

``ldconfig    ``    

`mysql   进入mysql`    

    update user set password=PASSWORD('new_password') where user='root';
    flush privileges
    exit

### 安装JDK环境
`cd /opt`  
`tar -zxvf jdk-8u171-linux-x64.tar.gz`  
`cp -rf jdk1.8.0_171 /usr/local/java`  
`vim /etc/profile`  

    export JAVA_HOME=${jdk source dir}
    CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
    PATH=$JAVA_HOME/bin:$PATH
    export PATH JAVA_HOME CLASSPATH  

`source /etc/profile`

`java -version （查看版本）`

### 安装maven
`yum install maven`  
`cd /opt/Tars/cpp/thirdparty`  
`chmod u+x thirdparty.sh`  
`./thirdparty.sh`  
### java语言框架开发环境安装
`cd /opt/Tars/java`    
`mvn clean install`  
`mvn clean install -f core/client.pom.xml`  
`mvn clean install -f core/server.pom.xml`  

> [ERROR] Unknown lifecycle phase "mvn". You must specify a valid lifecycle phase or a goal in the format <plugin-prefix>:<goal> or <plugin-group-id>:<plugin-artifact-id>[:<plugin-version>]:<goal>. Available lifecycle phases are: validate, initialize, generate-sources, process-sources, generate-resources, process-resources, compile, process-classes, generate-test-sources, process-test-sources, generate-test-resources, process-test-resources, test-compile, process-test-classes, test, prepare-package, package, pre-integration-test, integration-test, post-integration-test, verify, install, deploy, pre-clean, clean, post-clean, pre-site, site, post-site, site-deploy. -> [Help 1]
>
> 解决方案：
>
> ``mvn install``   
>
> `mvn compiler:compile   `
>
> `mvn org.apache.maven.plugins:maven-compiler-plugin:compile    `
>
> `mvn org.apache.maven.plugins:maven-compiler-plugin:2.0.2:compile   `
>
> 然后再执行：`mvn clean install -f core/client.pom.xml`  

### c++ 开发环境安装
`cd /opt/Tars/cpp/build`  
`chmod u+x build.sh`     
> 编译时默认使用的mysql开发库路径：include的路径为/usr/local/mysql/include，lib的路径为/usr/local/mysql/lib/，若mysql开发库的安装路径不在默认路径，则需要修改build目录下CMakeLists.txt文件中的mysql相关的路径，再编译  

`./build.sh all`  
`cd /usr/local`  
`mkdir tars`  
`chown cloud-user:cloud-user tars`  
`cd /opt/Tars/cpp/build`  
`./build.sh install`  
### mysql配置
`cd /opt/Tars/cpp/framework/sql`  
`vim exec-sql.sh`  

    mysql -u'root' -p'root' -e "create database db_tars"
    mysql -u'root' -p'root' -e "create database tars_stat"
    mysql -u'root' -p'root' -e "create database tars_property"
    mysql -u'root' -p'root' db_tars < db_tars.sql

``sed -i "s/192.168.2.131/${your machine ip}/g" `grep 192.168.2.131 -rl ./*` ``  
``sed -i "s/db.tars.com/${your machine ip}/g" `grep db.tars.com -rl ./*` ``  
``chmod u+x exec-sql.sh``  
``./exec-sql.sh``  
``mysql -uroot -p``    
``root``  
``grant all on *.* to 'tars'@'%' identified by 'password' with grant option;``  
``grant all on *.* to 'tars'@'localhost' identified by 'password' with grant option;``  
``grant all on *.* to 'tars'@'{你的机器名}' identified by 'password' with grant option;``  
``flush privileges;``  

### 安装Tars服务  
> 核心服务：tarsAdminRegistry,tarsregistry,tarsnode,tarsconfig,tarspath

> 普通基础服务：tarsstat,tarsproperty,tarsnotify,tarslog,tarsquerystat,tarsqueryproperty
一下几个make 是指打包服务，没有先后顺序和影响，framework是核心服务，打包该服务会在当前目录生成framework.tgz 包 这个包包含了 tarsAdminRegistry, tarsregistry, tarsnode, tarsconfig, tarspatch 部署相关的文件，将这个服务拷到/usr/local/app/tars/ 中，将里面IP、数据库密码替换成正确的；

``cd /opt/Tars/cpp/build ``  
``make framework-tar ``  
``make tarsstat-tar ``  
``make tarsnotify-tar ``  
``make tarsproperty-tar ``  
``make tarslog-tar ``  
``make tarsquerystat-tar ``  
``make tarsqueryproperty-tar ``  
``cd /usr/local ``  
``mkdir -p app/tars ``  
``chown -R cloud-user:cloud-user app ``  
``cd /opt/Tars/cpp/build/ ``  
``cp framework.tgz /usr/local/app/tars/ ``  
``cd /usr/local/app/tars ``  
``tar -zxvf framework.tgz ``  
``sed -i "s/192.168.2.131/${your machine ip}/g" `grep 192.168.2.131 -rl ./*` ``  
``sed -i "s/db.tars.com/${your machine ip}/g" `grep db.tars.com -rl ./*` ``  
``sed -i "s/registry.tars.com/${your machine ip}/g" `grep registry.tars.com -rl ./*` ``  
``sed -i "s/web.tars.com/${your machine ip}/g" `grep web.tars.com -rl ./*` ``  
``sed -i "s/tars2015/{$tars_password}/g" `grep tars2015 -rl ./*` ``  
``chmod u+x tars_install.sh ``  
``./tars_install.sh ``  
``tarspatch/util/init.sh ``  
``ps -ef | grep rsync 查看进程是否启动 ``  
``cd /opt/Tars/web ``  
``sed -i "s/tars2015/${mysql的tars密码}/g" `grep tars2015 -rl ./*` ``  
``sed -i "s/registry1.tars.com/${your machine ip}/g" `grep registry1.tars.com -rl ./*` ./src/main/resources/tars.conf\` ``  
``sed -i "s/registry2.tars.com/${your machine ip}/g" `grep registry2.tars.com -rl ./*` ./src/main/resources/tars.conf\` ``  
``mvn clean package ``  
``cp ./target/tars.war /usr/local/resin/webapps/ ``  
``mkdir -p /data/log/tars ``  

### 配置resin（新版本已经不使用）

> 修改Resin安装目录下的conf/resin.xml配置文件 将默认的配置

    <host id="" root-directory=".">
        <web-app id="/" root-directory="webapps/ROOT"/>
    </host>

修改为:  

    <host id="" root-directory=".">
        <web-app id="/" document-directory="webapps/tars"/>
    </host>

启动resin：`` /usr/local/resin/bin/resin.sh start ``  
查看tars所有进程 : `` ps -ef | grep tars ``   
杀死所有tars进程：``ps -ef | grep tars| grep -v grep |awk '{print $2}'|xargs kill -9``  
杀死某一端口进程：``netstat -apn | grep 19386|awk '{print $7}'|awk -F '/' '{print $1}'|xargs kill -9``



## web管理系统开发环境安装

以linux环境为例：

以官网提供的nvm脚本安装

执行以下命令：

```
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.bashrc
```

node和带有负载功能的node应用的进程管理器pm2安装

```
nvm install v8.11.3
npm install -g pm2 --registry=https://registry.npm.taobao.org
```

安装web管理页面依赖，启动web

```
cd web
npm install --registry=https://registry.npm.taobao.org
npm run prd
```

创建日志目录

```
mkdir -p /data/log/tars
```

#### 用户登录

导入数据库

db_tars_web.sql  、db_user_system.sql 注意库名

vim loginConf.js 修改以下

````
enableLogin: true,

loginUrl: 'http://外网IP:3001/login.html',

cookieDomain: '外网IP',

/**
 * 通过ticket获取用户信息的方法
 * @param {Object} ctx
 * @param {String} ticket
 */
function getUidByTicket(ctx, ticket) {
    // TODO 以下是示例代码，仅供参考
    return new Promise((resolve, reject)=>{
        request.get('http://外网IP:3001/api/getUidByTicket?ticket='+ticket).then(uidInfo=>{
            uidInfo = JSON.parse(uidInfo);
            resolve(uidInfo.data.uid);
        }).catch(err=>{
            reject(err);
        });
    })
}

/**
 * 校验ticket与uid是否相同的方法
 * @param {Object} ctx
 * @param {String} uid
 * @param {String} ticket
 */
function validate(ctx, uid, ticket) {
    //TODO 以下是示例代码，仅供参考
    return new Promise((resolve, reject)=>{
        request.get('http://外网IP:3001/api/validate?ticket='+ticket+'&uid='+uid).then(data=>{
            data = JSON.parse(data);
            resolve(data.data.result);
        }).catch(err=>{
            reject(err);
        });
    })
}
````

vim webConf.js  修改其中数据库配置

__修改启动登录服务__

``cd demo/config``

vim webConf.js 修改其中数据库配置

启动报错

错误日志：vim /root/.pm2/logs/tars-user-system-error.log

````
{ Error: Cannot find module 'memory-cache'
````

解决方案：npm install memory-cache

````
{ Error: Cannot find module 'sha1'
````

解决方案：npm install sha1

然后重启 Web服务

### 启动总结  

__命令：__    
``service mysql start``   
``/usr/local/app/tars/tars_install.sh``  
``/usr/local/app/tars/tarspatch/util/init.sh``  
``/usr/local/app/tars/tarsnode/bin/tarsnode --config=/usr/local/app/tars/tarsnode/conf/tarsnode.conf``  
``/usr/local/resin/bin/resin.sh start``  (新版本不使用)

> 部署各个服务，期间某些服务未部署前log中会有error，不影响，部署完了error会变少，但是还有，继续分析error

## 安装开发依赖  
### 安装php、php-swoole  
``wget http://hk2.php.net/get/php-7.2.8.tar.gz/from/this/mirror  ``  
``tar -zxvf mirror  ``  
``cd php-7.2.8  ``  
``yum install -y libxml2-devel libtool* curl-devel libjpeg-devel libpng-devel freetype-devel libxmal2 libxml2-devel openssl openssl-devel curl curl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel pcre pcre-devel libxslt libxslt-devel bzip2 bzip2-devel  ``  
没有configure ``则先phpize;  ``  
``./configure --prefix=/usr/local/php --enable-fpm --enable-opcache --with-config-file-path=/usr/local/php/etc  --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-static --enable-sockets --enable-wddx --enable-zip --enable-calendar --enable-bcmath --enable-soap --with-zlib --with-iconv --with-freetype-dir --with-gd --with-jpeg-dir --with-xmlrpc --enable-mbstring --with-sqlite3 --with-curl --enable-ftp  --with-openssl  --with-gettext  ``  
``make  ``  
``make install  ``  
``将文件中php.ini-development 复制到 /usr/local/php/etc/php.ini  ``  
``cp php.ini-development /usr/local/php/etc/php.ini  ``  
``vim /usr/local/php/etc/php.ini  ``  

    date.timezone = PRC

``cd /opt/php-7.2.8/sapi/fpm  ``  
``cp init.d.php-fpm /etc/init.d/php-fpm  ``  
``cd /usr/local/php/etc/  ``  
``cp php-fpm.conf.default php-fpm.conf  ``  
``cd /usr/local/php/etc/php-fpm.d  ``  
``cp www.conf.default www.conf  ``  
``vim /etc/profile.d/php.sh  ``  

    export PATH=$PATH:/usr/local/php/bin/:/usr/local/php/sbin/

``source /etc/profile.d/php.sh  ``  
启动：php-fpm    
查看PHP配置：``php --ini   ``  ;确保Configuration File (php.ini) Path 和Loaded Configuration File路径准确;

查看php-fpm进程状态：``netstat -tln | grep 9000  ``
#### swoole:
``wget http://pecl.php.net/get/swoole-2.2.0.tgz  ``  
``tar -zxvf swoole-2.2.0.tgz  ``  
``cd swoole-2.2.0  ``  
``phpize  ``  
``./configure --with-php-config=/usr/local/php/bin/php-config ``   

``make && make install  ``  
``vim /usr/local/php/etc/php.ini  ``  

    extension=swoole.so

查看swoole扩展是否安装成功：''php -m | grep swoole  ``  

#### Tars扩展：
``cd /opt/Tars/php/tars-extension  ``  
``phpize  ``  
``./configure --with-php-config=/usr/local/php/bin/php-config --enable-phptars  ``  
``make && make install  ``  
``vim /usr/local/php/etc/php.ini  ``   

    extension=phptars.so

查看PHPTars扩展是否安装成功：``php -m | grep tars``  

#### PHP服务模版配置
    > 每个Tars服务启动运行时，必须指定一个模版配置文件，在Tars web管理系统中部署的服务的模版配置由node进行组织生成，若不是在web管理系统上，则需要自己创建一个模版文件。具体https://github.com/Tencent/Tars/blob/phptars/docs/tars_template.md
对php开发，首先在web管理界面中->运维管理->模板管理，找到tars.tarsphp.default模板，根据实际安装的php可执行文件php位置修改，如:
php=/usr/bin/php/bin/php

同时，将tars.tarsphp.default内容复制，新建tcp和http版本的模板 相比较将tars.tarsphp.default,http模板，差异为：  
http模板在server节点增加：  

    protocolName=http
    type=http

TCP模板在server节点增加：

    package_length_type=N
    open_length_check=1
    package_length_offset=0
    package_body_offset=0
    package_max_length=2000000
    protocolName=tars
    type=tcp

_注:_

> 父模板名均选择tars.default即可

> 文档中protocolName、type的说明缺失，实际使用中发现会报错，保险起见按照以上说明配置

> 部署申请中服务类型为对应的语言



## 开机启动

添加文件

vim /etc/init.d/tars.sh

`````
#!/bin/bash
#chkconfig:345 61 61 //此行的345参数表示,在哪些运行级别启动,启动序号(S61);关闭序号(K61)
#description:myself//此行必写,描述服务.
systemctl stop iptables
service mysql start
currentTimeStamp=`date "+%Y%m%d%H%M%S"`
tar -cf /data/tars/app_log/tars_log_${currentTimeStamp}.tar /data/tars/app_log/tars/*
rm -rf /data/tars/app_log/tars/*
/usr/local/app/tars/tars_install.sh
/usr/local/app/tars/tarspatch/util/init.sh
netstat -apn | grep 19385|awk '{print $7}'|awk -F '/' '{print $1}'|xargs kill -9
/usr/local/app/tars/tarsnode/bin/tarsnode --config=/usr/local/app/tars/tarsnode/conf/tarsnode.conf
/usr/local/resin/bin/resin.sh start
`````

添加到开机启动

````
cd /etc/rc.d/init.d
chkconfig --add tars.sh
chkconfig tars.sh on
````



## TimerJob

tars模版中新建timer模版，copy对应服务端\客户端的模版内容，其中添加isTimer=1;继承tars.default

````
<tars>
 <application>
   <server>
      isTimer=1
    </server>
 </application>
</tars>
````

server中建timer目录

目录下建NameQueueTimer.php文件

````
<?php
namespace TimerServer\timer;
class NameQueueTimer {
    public $interval;
    public function __construct()
    {
        $this->interval = 10000; //单位为毫秒
    }
    public function execute() {
        // 你的业务代码
    }
}
````



修改：src/vendor/phptars/tars-server/src/core/Server.php 【问题已解决】

````
83行 添加	}
````

````
84-94行 删除
			// 判断是否是timer服务
            if (isset($this->tarsConfig['tars']['application']['server']['isTimer']) &&
                $this->tarsConfig['tars']['application']['server']['isTimer'] == true) {
                $timerDir = $this->basePath.'src/timer/';
                if (is_dir($timerDir)) {
                    $files = scandir($timerDir);
                    foreach ($files as $f) {
                        $fileName = $timerDir.$f;
                        if (is_file($fileName) && strrchr($fileName, '.php') == '.php') {
                            $this->timers[] = $fileName;
                        }
添加
	     // 判断是否是timer服务
        if (isset($this->tarsConfig['tars']['application']['server']['isTimer']) &&
            $this->tarsConfig['tars']['application']['server']['isTimer'] == true) {
            $timerDir = $this->basePath.'src/timer/';
            if (is_dir($timerDir)) {
                $files = scandir($timerDir);
                foreach ($files as $f) {
                    $fileName = $timerDir.$f;
                    if (is_file($fileName) && strrchr($fileName, '.php') == '.php') {
                        $this->timers[] = $fileName;
````

````
96-97 删除
                } else {
                    error_log('timer dir missing');
````

````
98 添加
 			} else {
                error_log('timer dir missing');
````

````
186-187 删除
 		} else {
            $this->namespaceName = $this->servicesInfo['namespaceName'];
````

````
188 添加
$this->namespaceName = isset($this->servicesInfo['namespaceName']) ? trim($this->servicesInfo['namespaceName']) : '';
````

![image-20180905213623425](https://github.com/jackylee92/Blog/blob/master/Images/tars_timer1.png?raw=true)

![image-20180905213710884](https://github.com/jackylee92/Blog/blob/master/Images/tars_timer2.png?raw=true)



## mysqli-database-class

````
composer joshcam/mysqli-database-class
````

注意vendor/joshcam/mysqli-database-class/dbObject.php中$db 的权限

## Question

* log报错：swoole WARNING	swShareMemory_mmap_create: mmap(396932556) failed. Error: Cannot allocate memory[12]

  查看该服务log文件过大，无法打开，删除重新建立

* 启动Client时log报错：home-class or home-api not exist, please chech services.php!

  查看 管理Servant-编辑-协议项是否为"非tars"；应选择"非TARS"

* 服务发布成功，但log日志中：notice: Undefined offset: 3 in /usr/local/app/tars/tarsnode/data/User.Server/bin/src/vendor/phptars/tars-server/src/protocol/TARSProtocol.php on line 228

	查看.tars文件 out 参数后面加数据类型 后还需要加 变量 例如：int index(User user, out User data)



* 服务log一直刷 致命错误：ERROR	swManager_loop(:299): wait() failed. Error: No child processes[10]. PHP log：must be compatible

  查看impl下的Class方法参数，参数是否与接口一直



* Client log报出：Warning: Swoole\Http\Response::end(): Http request is finished

  查看代码，controller 中 方法结束地方有没有return



* 启动的时候失败，日志报出：ERROR	swManager_loop(:474): waitpid(159038) failed. Error: No child processes[10]

  内存不够：目前方式是重启了机器



* php log日志中报出：PHP Fatal error:  Redefinition of parameter $param

  检查impl定义的方法，方法中的参数变量名是否重复



* log:  PHP Warning:  unpack(): Type N: not enough input, need 4, have 0 in /usr/local/app/tars/tarsnode/data/Search.Client/bin/src/vendor/phptars/tars-client/src/Communicator.php on line 378

  检查函数调用的数据类型，最好都要(int)、(string)强转



* 插入数据时log：preg_match(): Delimiter must not be alphanumeric or backslash in /usr/local/app/tars/tarsnode/data/Job.Yqzl/bin/src/vendor/joshcam/mysqli-database-class/dbObject.php on line 667

  该表的类中数据类型错误，数据库中varchar在模型类中为text bigint为int



* 启动web是log中提示：

   Unknown or incorrect time zone: '+-4:00'\n at Utils.Promise.tap.then.catch.err

  解决方案：修改服务器时间区域，时间区域应为[CST] 1：

````
mv /etc/localtime /etc/localtime.bak  
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
重启mysql
重启web
````



需要替换的:10.120.129.226  192.168.2.131 10.211.55.7

````
framwork

sed -i "s/10.120.129.226/${YouIp}/g" `grep 10.120.129.226 -rl ./*`

sed -i "s/db.tars.com/${YouIp}/g" `grep db.tars.com -rl ./*`

sed -i "s/web.tars.com/${YouIp}/g" `grep web.tars.com -rl ./*`

sed -i "s/tars2015/${MySqlPwd}/g" `grep tars2015 -rl ./*`

sed -i "s/192.168.2.131/${YouIp}/g" `grep 192.168.2.131 -rl ./*`

sed -i "s/web.tars.com/${YouIp}/g" `grep web.tars.com -rl ./*`

sed -i "s/registry.tars.com/${YouIp}/g" `grep registry.tars.com -rl ./*`
````



#### 开发

* 寻址

  ````
  $wrapper = new \Tars\registry\QueryFWrapper("tars.tarsregistry.QueryObj@tcp -h 192.168.163.128 -p 17890", 1, 60000);
  $result = $wrapper->findObjectById("Article.Server.Obj");
  var_dump($result);
  ````

### doTars实现方案

* 建立自己的github仓库

* 建立自己的packlist仓库

* 仓库中composer.json

  ````
  {
      "name" : "doTars",
      "description": "goTars",
      "require": {
      	"ljd/dotars-init": "v1",
          "phptars/tars-server": "~0.1",
          "phptars/tars-deploy": "~0.1",
          "phptars/tars2php": "~0.1",
          "phptars/tars-log": "~0.1",
          "ext-zip" : ">=0.0.1",
          ...
          ...
      },
      "autoload": {
          "psr-4": {
              "doTars\\" : "./"
          }
      },
      "minimum-stability": "stable",
      "scripts" : {
          "deploy" : "\\Tars\\deploy\\Deploy::run"，
          "post-install-cmd": "dotars\\DotarsInit::dotarsInit"
      },
      "repositories": {
          "packagist": {
              "type": "composer",
              "url": "https://packagist.laravel-china.org/"
          }
      }
  }
  
  ````

* 创建一个doTars-init包，该包有一个DotarsInit类，该类主要是在composer create-project 后以交互的形式获取ServerName AppName ObjName 主控IP(支持数组多主控)完成框架搭建，并填入相应的目录中这些参数