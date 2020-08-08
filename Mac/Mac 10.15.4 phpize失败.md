 [TOC]

# MAC 编译安装php扩展失败

### 环境 

mac 10.15.4

### 报错

phpize：

````
grep: /usr/include/php/main/php.h: No such file or directory
grep: /usr/include/php/Zend/zend_modules.h: No such file or directory
grep: /usr/include/php/Zend/zend_extensions.h: No such file or directory
Configuring for:
PHP Api Version:        
Zend Module Api No:     
Zend Extension Api No:  
Cannot find autoconf. Please check your autoconf installation and the
$PHP_AUTOCONF environment variable. Then, rerun this script
````

上面出现了两种错误

php.h 和 autoconf

因为苹果在新版中引入了新的[安全机制](https://support.apple.com/en-us/HT210650)

解决方案：

1. 先找到你的php.h

   ```
   sudo find /Library -name php.h
   >>>
   /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/php/main/php.h
   /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include/php/main/php.h
   ```

2. 找到phpize

   ````
   whereis phpize
   >>> /usr/bin/phpize
   ````

3. 将 phpize和php-config复制到usr/local/bin中修改

   ````
   cp /usr/bin/phpize /usr/local/bin/phpize
   cp /usr/bin/php-config /usr/local/bin/php-config
   ````

4. 修改 /usr/local/bin/phpize 和 /usr/local/bin/php-config

   vim /usr/local/bin/phpize 第8行

   ````
   # includedir="`eval echo ${prefix}/include`/php" # 20200514修改 lijundong
   includedir="`eval echo /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include`/php"
   ````

   vim /usr/local/bin/php-config 第9行

   ````
   # include_dir="${prefix}/include/php" # 2020 0515 lijundong
   include_dir="/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include/php"
   includes="-I$include_dir -I$include_dir/main -I$include_dir/TSRM -I$include_dir/Zend -I$include_dir/ext -I$include_dir/ext/date/lib"
   ````

5. 安装autoconf

   ````
   brew install autoconf
   ````

### 再次安装

````
./configure --with-php-config=/usr/local/bin/php-config
make
mkdir ~/Dev/PHP/extensions
cp modules/blitz.so ~/Dev/PHP/extensions
````

sudo vim /etc/php.ini 加入

````
extension=/Users/adong/Dev/PHP/extensions/blitz.so
````

php-m 查看成功
