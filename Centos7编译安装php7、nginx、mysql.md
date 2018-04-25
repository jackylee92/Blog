# Centos7编译安装php7、nginx、mysql

> 整理之前centos7编译安装php、yum 安装 nginx、mysql服务；除php、nginx、mysql【简单】

__PHP__

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
> 缺少什么组件在安装；

出现错误，解决方案

````
freetype.h not fount　　=>　　yum install freetype-devel 
```` 

````
configure: error: Please reinstall the libcurl distribution - easy.h should be in /include/curl/　　=>　　yum install curl curl-devel
````

````
annot find openssl's<evp.h>　　=>　　yum install openssl openssl-devel 
````

````
configure error xml2-config not found. please check your libxml2 installation　　=>　　yum install libxml2 libxml2-devel 
````

````
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
打开php配置文件找到cgi.fix_pathinfo配置项，这一项默认被注释并且值为1，根据官方文档的说明，这里为了当文件不存在时，阻止Nginx将请求发送到后端的PHP-FPM模块，从而避免恶意脚本注入的攻击，所以此项应该去掉注释并设置为0

修改php-fpm
然后网上一些教程说让修改php-fpm.conf添加以上创建的用户和组，
vim /usr/local/php/etc
默认情况下etc/php-fpm.d/下有一个名为www.conf.defalut的配置用户的文件，执行下面命令复制一个新文件并且打开：
cp www.conf.default www.conf
vi www.conf
默认user和group的设置为nobody，将其改为合适的。

启动php-fpm

````
/usr/local/bin/php-fpm
````
配置环境变量

vim /etc/profile
PATH=$PATH:/usr/local/php/bin

export PATH

source /etc/profile

即可