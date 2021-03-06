[TOC]



# Centos7编译安装php7、nginx、mysql

> 整理之前centos7编译安装php、yum 安装 nginx、mysql服务；除php、nginx、mysql【简单】

##PHP

* 下载php7安装包:

````
wget http://cn2.php.net/get/php-7.0.2.tar.gz/from/this/mirror
tar -zxvf php-7.1.0.tar.gz
````
* 安装需要的软件支持:

````
yum install libxmal2 libxml2-devel openssl openssl-devel curl curl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel pcre pcre-devel libxslt libxslt-devel bzip2 bzip2-devel
````
* 进入解压后的文件,检测：

````
cd php-7.0.2
./configure –prefix=/usr/local/php –with-curl –with-freetype-dir –with-gd –with-gettext –with-iconv-dir –with-kerberos –with-libdir=lib64 –with-libxml-dir –with-mysqli –with-openssl –with-pcre-regex –with-pdo-mysql –with-pdo-sqlite –with-pear –with-png-dir –with-jpeg-dir –with-xmlrpc –with-xsl –with-zlib –with-bz2 –with-mhash –enable-fpm –enable-bcmath –enable-libxml –enable-inline-optimization –enable-gd-native-ttf –enable-mbregex –enable-mbstring –enable-opcache –enable-pcntl –enable-shmop –enable-soap –enable-sockets –enable-sysvsem –enable-sysvshm –enable-xml –enable-zip
````

> 缺少什么组件在安装；出现错误，解决方案


````
freetype.h not fount =>　yum install freetype-devel

configure: error: Please reinstall the libcurl distribution - easy.h should be in /include/curl/　　=>　　yum install curl curl-devel

annot find openssl's<evp.h>　　=>　　yum install openssl openssl-devel

configure error xml2-config not found. please check your libxml2 installation　　=>　　yum install libxml2 libxml2-devel 

png.h not found.　　=>　　yum install libpng-devel ````    
````

````
make && make install
````

配置相应的php文件:

````
cp php.ini-development /usr/local/php/php.ini    
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf    
cp sapi/fpm/php-fpm /usr/local/bin
````
设置php.ini文件

````
vi /usr/local/php/php.ini
````
<delete>打开php配置文件找到cgi.fix_pathinfo配置项，这一项默认被注释并且值为1，根据官方文档的说明，这里为了当文件不存在时，阻止Nginx将请求发送到后端的PHP-FPM模块，从而避免恶意脚本注入的攻击，所以此项应该去掉注释并设置为0

修改php-fpm
然后网上一些教程说让修改php-fpm.conf添加以上创建的用户和组，
vim /usr/local/php/etc
默认情况下etc/php-fpm.d/下有一个名为www.conf.defalut的配置用户的文件，执行下面命令复制一个新文件并且打开：
cp www.conf.default www.conf
vi www.conf 
默认user和group的设置为nobody，将其改为合适的。</delete>



``php --ini ``检查配置：

````
Configuration File (php.ini) Path: /usr/local/php/lib
Loaded Configuration File:         /usr/local/php/lib/php.ini
Scan for additional .ini files in: (none)
Additional .ini files parsed:      (none)
````

第一个表示安装路径须正确；

第二个位加载的php.ini配置文件，须正确；

后面两个暂未知；

``php-config`` 显示扩展、版本等信息；

````
Usage: /usr/local/php/bin/php-config [OPTION]
Options:
  --prefix            [/usr/local/php]
  --includes          [-I/usr/local/php/include/php -I/usr/local/php/include/php/main -I/usr/local/php/include/php/TSRM -I/usr/local/php/include/php/Zend -I/usr/local/php/include/php/ext -I/usr/local/php/include/php/ext/date/lib]
  --ldflags           []
  --libs              [-lcrypt   -lz -lexslt -lresolv -lcrypt -lrt -lpng -lz -ljpeg -lbz2 -lz -lrt -lm -ldl -lnsl  -lxml2 -lz -lm -ldl -lgssapi_krb5 -lkrb5 -lk5crypto -lcom_err -lssl -lcrypto -lcurl -lxml2 -lz -lm -ldl -lfreetype -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lcrypt -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lxslt -lxml2 -lz -ldl -lm -lssl -lcrypto -lcrypt ]
  --extension-dir     [/usr/local/php/lib/php/extensions/no-debug-non-zts-20170718]
  --include-dir       [/usr/local/php/include/php]
  --man-dir           [/usr/local/php/php/man]
  --php-binary        [/usr/local/php/bin/php]
  --php-sapis         [ cli fpm phpdbg cgi]
  --configure-options [--prefix=/usr/local/php --with-curl --with-freetype-dir --with-gd --with-gettext --with-iconv-dir --with-kerberos --with-libdir=lib64 --with-libxml-dir --with-mysqli --with-openssl --with-pcre-regex --with-pdo-mysql --with-pdo-sqlite --with-pear --with-png-dir --with-jpeg-dir --with-xmlrpc --with-xsl --with-zlib --with-bz2 --with-mhash --enable-fpm --enable-bcmath --enable-libxml --enable-inline-optimization --enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --enable-shmop --enable-soap --enable-sockets --enable-sysvsem --enable-sysvshm --enable-xml --enable-zip]
  --version           [7.2.0]
  --vernum            [70200]
````



启动php-fpm

````
/usr/local/bin/php-fpm
````
配置环境变量

vim /etc/profile
PATH=$PATH:/usr/local/php/bin

export PATH

source /etc/profile

### PHP7.2

* 删除原PHP

  `` yum remove php ``

  `` whereis php ``

  `` rm -rf xxx `` 删除对应的文件夹

* 下载php7.2

  `` wget http://hk2.php.net/get/php-7.2.8.tar.gz/from/this/mirror ``

* 解压

  `` tar -xvf php-7.2.8.tar.gz ``

* 安装所需程序

  `` yum install -y libxml2-devel libtool* curl-devel libjpeg-devel libpng-devel freetype-devel libxmal2 libxml2-devel openssl openssl-devel curl curl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel pcre pcre-devel libxslt libxslt-devel bzip2 bzip2-devel ``

* 编译安装

  `` cd php-7.2.8 ``

  `` ./configure --prefix=/usr/local/php --enable-fpm --enable-opcache --with-config-file-path=/usr/local/php/etc --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-static --enable-sockets --enable-wddx --enable-zip --enable-calendar --enable-bcmath --enable-soap --with-zlib --with-iconv --with-freetype-dir --with-gd --with-jpeg-dir --with-xmlrpc --enable-mbstring --with-sqlite3 --with-curl --enable-ftp --with-openssl --with-gettext ``

  `` make && make install``

  `` cp php.ini-development /usr/local/php/etc/php.ini ``

  `` vim /usr/local/php/etc/php.ini ``

  ````
  date.timezone = PRC
  ````

  `` cd /opt/php-7.2.8/sapi/fpm ``

  ``  cp init.d.php-fpm /etc/init.d/php-fpm `` 
   ``  cd /usr/local/php/etc/  ``
   ``  cp php-fpm.conf.default php-fpm.conf  ``	
   ``  cd /usr/local/php/etc/php-fpm.d ``		
   ``  cp www.conf.default www.conf ``		
   ``  vim /etc/profile.d/php.sh ``		
   ``  source /etc/profile.d/php.sh ``		

* 重启

  `` killall php-fpm ``

* 查看版本，看配置

  ``php -v ``
   ``  php --ini ``

### PHP7.2 安装swoole

* 下载解压swoole

  `` wget https://gitee.com/swoole/swoole/repository/archive/v2.2.0.zip``

  `` unzip v2.2.0.zip ``

* 编译安装

  `` ./configure --with-php-config=/usr/local/php/bin/php-config ``
   ``  make ``
   ``  make install ``

  > Phpize 提示错误：The php-devel package is required for use of this command.  
  >
  > 解决方案： yum install php70w-deve

  `` vim /usr/local/php/etc/php.ini `` 添加：

  ````
  extension=swoole.so
  ````

* 查看结果：

  `` php -m | grep swoole``

## 安装Composer

* 下载：

  `` curl -sS https://getcomposer.org/installer | php ``

* copy到环境变量中

  `` mv composer.phar /usr/bin/composer ``

## 安装php mongodb扩展

````
wget http://pecl.php.net/get/mongodb-1.5.1.tgz
````

## 安装php redis扩展

````
wget https://github.com/phpredis/phpredis/archive/develop.zip -O redis.zip
````

## 安装php oracle扩展 

### 安装InstantClient

> instantclient是oracle的连接数据库的简单客户端，从[ 这里](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) 选择需要的版本下载，只需Basic和Devel两个rpm包。

````
wget http://download.oracle.com/otn/linux/instantclient/11204/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
wget https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
rpm -ivh oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
rpm -ivh oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
````

> \#64位系统需要创建32位的软链接，这里可能是一个遗留bug，不然后面编译会出问题
>
> ln -s /usr/include/oracle/11.2/client64 /usr/include/oracle/11.2/client
>
> ln -s /usr/lib/oracle/11.2/client64 /usr/lib/oracle/11.2/client

接下来还要让系统能够找到oracle客户端的库文件，修改LD_LIBRARY_PATH

在/etc/profile.d/下面新建oracle.sh文件

vi /etc/profile.d/oracle.sh

````
export ORACLE_HOME=/usr/lib/oracle/11.2/client64
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
````

执行source /etc/profile.d/oracle.sh使环境变量生效。

### 安装PHP oci8扩展

````
# 下载解压
wget http://pecl.php.net/get/oci8-2.1.0.tgz
tar -zxvf oci8-2.1.0.tgz
cd oci8-2.1.0
# 编译安装
phpize
./configure --with-oci8=shared,instantclient,/usr/lib/oracle/11.2/client64/lib --with-php-config=/usr/local/php/bin/php-config
make && make install
# 编译成功会生成文件
ll /usr/local/php/lib/php/extensions/no-debug-non-zts-20170718/
# 添加扩展到php.ini中
vim /usr/local/php/etc/php.ini
# 查看
php -m | grep oci8
````



## Nginx

### yum install nginx -y

> 没有镜像源 解决方案

官网：https://dl.fedoraproject.org/pub/epel/

具体地址：https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm

````
wget https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
rpm -ivh epel-release-7-11.noarch.rpm
yum install nginx -y
````

如果网站放在home中 home一下的目录权限应设置为755 文件的权限为664

安装gitlab， kill -9 nginx主进程号  nginx无法关闭，

原因 

gitlab-ctl 守护进程会启动的 nginx.
要使用gitlab-ctl stop nginx