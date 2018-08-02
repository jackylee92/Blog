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

## __以下为多次安装后总结简单具体步骤__

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

##安装服务器环境
### install (提前安装好需要的扩展)
    yum install -y gcc gcc-c++ bison flex glibc-devel ncurses-devel perl perl-Module-Install.noarch git zlib-devel ncurses-devel curl-devel autoconf
###  关闭selinux防火墙  
    setenforce 0    
### 准备软件包：  
1. jdk-8u171-linux-x64.tar.gz 
2. resin-pro-4.0.56.tar.gz
3. cmake-3.6.2.tar.gz
4. mysql-5.6.25.tar.gz
5. swoole-4.0.1.tgz
6. Tars  
`cd /opt`  
`git clone https://github.com/Tencent/Tars.git`  
### 安装Cmake  
`tar -zxvf cmake-3.6.2.tar.gz`  
`cd cmake-3.6.2`  
`./bootstrap`  
`make`  
`make install`  
### 安装resion
`tar -zxvf resin-pro-4.0.56.tar.gz`  
`cp -rf resin-pro-4.0.56 /usr/local/resin`  
### 安装mysql
`tar -zxvf mysql-5.6.25.tar.gz`  
` cd mysql-5.6.25`  
`cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DWITH_INNOBASE_STORAGE_ENGINE=1 -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci`  
`make`  
`make install`  
`chown -R mysql:mysql /usr/local/mysql/`  
`cd /usr/local/mysql/`  
`cp support-files/mysql.server /etc/init.d/mysq`  
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
    
    perl scripts/mysql_install_db --user=mysql

### 配置mysql
`service mysql start`  
`chkconfig mysql on`  
`vim /etc/profile`  

    PATH=$PATH:/usr/local/mysql/bin
    
`export PATH`  
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
``mkdir -f app/tars ``  
``chown -R cloud-user:cloud-user app ``  
``cd /opt/Tars/cpp/build/ ``  
``cp framework.tgz /usr/local/app/tars/ ``  
``cd /usr/local/app/tars ``  
``tar -zxvf framework.tgz ``  
``sed -i "s/192.168.2.131/${your machine ip}/g" \`grep 192.168.2.131 -rl ./*\` ``  
``sed -i "s/db.tars.com/${your machine ip}/g" \`grep db.tars.com -rl ./*\` ``  
``sed -i "s/registry.tars.com/${your machine ip}/g" \`grep registry.tars.com -rl ./*\` ``  
``sed -i "s/web.tars.com/${your machine ip}/g" \`grep web.tars.com -rl ./*\` ``  
``sed -i "s/tars2015/{$tars_password}/g" \`grep tars2015 -rl ./*\` ``  
``chmod u+x tars_install.sh ``  
``./tars_install.sh ``  
``tarspatch/util/init.sh ``  
``ps -ef | grep rsync 查看进程是否启动 ``  
``cd /opt/Tars/web ``  
``sed -i "s/tars2015/${mysql的tars密码}/g" \`grep tars2015 -rl ./*\` ``  
``sed -i "s/registry1.tars.com/${your machine ip}/g" \`grep registry1.tars.com -rl ./src/main/resources/tars.conf\` ``  
``sed -i "s/registry2.tars.com/${your machine ip}/g" \`grep registry2.tars.com -rl ./src/main/resources/tars.conf\` ``  
``mvn clean package ``  
``cp ./target/tars.war /usr/local/resin/webapps/ ``  
``mkdir -p /data/log/tars ``  

### 配置resin

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

### 启动总结  
__命令：__    
``service mysql start``   
``/usr/local/app/tars/tars_install.sh``  
``/usr/local/app/tars/tarspatch/util/init.sh``  
``/usr/local/app/tars/tarsnode/bin/tarsnode --config=/usr/local/app/tars/tarsnode/conf/tarsnode.conf``  
``/usr/local/resin/bin/resin.sh start``  

> 部署各个服务，期间某些服务未部署前log中会有error，不影响，部署完了error会变少，但是还有，继续分析error

##安装开发依赖
###安装php、php-swoole
``wget http://cn2.php.net/get/php-7.0.2.tar.gz/from/this/mirror  ``  
``tar -zxvf mirror  ``  
``cd php-7.0.2  ``  
``yum install -y libxml2-devel libtool* curl-devel libjpeg-devel libpng-devel freetype-devel libxmal2 libxml2-devel openssl openssl-devel curl curl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel pcre pcre-devel libxslt libxslt-devel bzip2 bzip2-devel  ``  
没有configure ``则先phpize;  ``  
``./configure --prefix=/usr/local/php --enable-fpm --enable-opcache --with-config-file-path=/usr/local/php/etc  --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-static --enable-sockets --enable-wddx --enable-zip --enable-calendar --enable-bcmath --enable-soap --with-zlib --with-iconv --with-freetype-dir --with-gd --with-jpeg-dir --with-xmlrpc --enable-mbstring --with-sqlite3 --with-curl --enable-ftp  --with-openssl  --with-gettext  ``  
``make  ``  
``make install  ``  
``将文件中php.ini-development 复制到 /usr/local/php/etc/php.ini  ``  
``cp php.ini-development /usr/local/php/etc/php.ini  ``  
``vim /usr/local/php/etc/php.ini  ``  

    date.timezone = PRC
    
``cd /opt/php-7.0.2/sapi/fpm  ``  
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
``./configure  ``  
``make && make install  ``  
``vim /use/local/php/etc/php.ini  ``  

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

    protocolName=http​
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


