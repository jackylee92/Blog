## Tars

* 环境依赖

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

* install gcc

  ````
  yum install gcc
  ````

* install bison
  ````
  yum install bison
  ````

* install flex

  ````
  yum install flex
  ````

  

* install glibc-devel

  ````
  yum install glibc-devel
  ````

* install cmake

  ````
  下载cmake
  # 解压
  tar zxvf cmake-3.6.2.tar.gz
  # 进入cmake-3.6.2
  ./bootstrap
  cd cmake-3.6.2
  # 安装
  make
  make install
  ````

  问题：

  > make: *** 没有指明目标并且找不到 makefile。 停止。
  >
  > Cannot find appropriate C++ compiler on this system
  >
  > Curses libraries were not found. Curses GUI for CMake will not be built
  >
  > 解决方案：yum install gcc-c++ ncurses-devel curl-devel 
  > 


* install resin 

  ````
  下载resin-pro-4.0.56.tar.gz
  # 解压resin-pro-4.0.56.tar.gz
  tar zxvf resin-pro-4.0.56.tar.gz
  # 将resin-pro-4.0.56 copy到/use/local/resin
  ````

* install ncurses-devel
  ````
  yum install ncurses-devel
  ````

* install zlib-devel
  ````
  yum install zlib-devel
  ````

* install mysql

  ````
  # 下载mysql-5.6.25.tar到opt中
  # 创建mysql 用户、用户组
  groupadd mysql
  useradd mysql
  cd /use/local
  mkdir mysql-5.6.25
  chown mysql:mysql mysql-5.6.25
  cd /opt
  tar -zxvf mysql-5.6.25
  cd mysql-5.6.25
  cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.6.25 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
  
  yum install perl
  cd /usr/local/mysql
  useradd mysql
  rm -rf /usr/local/mysql/data
  mkdir -p /data/mysql-data
  ln -s /data/mysql-data /usr/local/mysql/data
  chown -R mysql:mysql /data/mysql-data /usr/local/mysql/data
  cp support-files/mysql.server /etc/init.d/mysql
  **如果/etc/目录下有my.cnf存在，需要把这个配置删除了**
  yum install -y perl-Module-Install.noarch
  perl scripts/mysql_install_db --user=mysql
  vim /usr/local/mysql/my.cnf
  
  # 修改my.cnf
  vim my.cnf
  [mysqld]
  
  # Remove leading # and set to the amount of RAM for the most important data
  # cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
  innodb_buffer_pool_size = 128M
  
  # Remove leading # to turn on a very important data integrity option: logging
  # changes to the binary log between backups.
  log_bin
  
  # These are commonly set, remove the # and set as required.
  basedir = /usr/local/mysql
  datadir = /usr/local/mysql/data
  # port = .....
  # server_id = .....
  socket = /tmp/mysql.sock
  
  bind-address={$your machine ip}
  
  # Remove leading # to set options mainly useful for reporting servers.
  # The server defaults are faster for transactions and fast SELECTs.
  # Adjust sizes as needed, experiment to find the optimal values.
  join_buffer_size = 128M
  sort_buffer_size = 2M
  read_rnd_buffer_size = 2M
  
  sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
  ````

  > $your machine ip 为ifconfig 的IP

* install java

  ````
  # 下载jdk-8u171-linux-x64.tar.gz
  # 解压 jdk-8u171-linux-x64.tar.gz
  tar -zxvf jdk-8u171-linux-x64.tar.gz
  cp -r jdk-8u171-linux-x64 /use/local/java
  
  vim /etc/profile
  
  export JAVA_HOME=${jdk source dir}
  CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
  PATH=$JAVA_HOME/bin:$PATH
  export PATH JAVA_HOME CLASSPATH
  
  source /etc/profile
  
  java -version
  ````

* install maven

  ````
  yum install maven
  mvn -v
  ````

* tars源码

  ````
  wget https://github.com/Tencent/Tars.git
  cd Tars/java
  
  mvn clean install 
  mvn clean install -f core/client.pom.xml 
  mvn clean install -f core/server.pom.xml
  
  cd /opt/Tars/cpp/thirdparty/
  chmod u+x thirdparty.sh
  ./thirdparty.sh
  
  cd ../build
  chmod u+x build.sh
  ./build.sh all
  
  cd /usr/local
  mkdir tars
  chown ${普通用户}:${普通用户} ./tars/
  
  cd {$source_folder}/cpp/build
  ./build.sh install或者make install
  ````

  > c++: 编译器内部错误：已杀死(程序 cc1plus)
  >
  > 解决方案：可能是内存小了，增加内存
  >
  > **编译时默认使用的mysql开发库路径：include的路径为/usr/local/mysql/include，lib的路径为/usr/local/mysql/lib/，若mysql开发库的安装路径不在默认路径，则需要修改build目录下CMakeLists.txt文件中的mysql相关的路径，再编译**

* Mysql 用户

  ````
  grant all on *.* to 'tars'@'%' identified by 'tars2015' with grant option;
  grant all on *.* to 'tars'@'localhost' identified by 'tars2015' with grant option;
  grant all on *.* to 'tars'@'${主机名}' identified by 'tars2015' with grant option;
  flush privileges;
  ````

* Mysql tars 数据库

  ````
  sql脚本在cpp/framework/sql目录下，修改部署的ip信息
  创建三个数据库 db_tars、tars_stat、tars_property。
  往db_tars中添加数据
  ````

* 基础服务安装

  ````
  # 在当前目录生成framework.tgz 包 这个包包含了 tarsAdminRegistry, tarsregistry, tarsnode, tarsconfig, tarspatch 部署相关的文件
  make framework-tar
  
  # 第二种服务安装包可以单独准备,生成的发布包，在管理平台部署发布完成后，进行部署发布
  make tarsstat-tar
  make tarsnotify-tar
  make tarsproperty-tar
  make tarslog-tar
  make tarsquerystat-tar
  make tarsqueryproperty-tar
  ````

* 核心基础服务安装

  ````
  # 切换至root用户，创建基础服务的部署目录，如下：
  cd /usr/local/app
  mkdir tars
  chown ${普通用户}:${普通用户} ./tars/
  
  # 将已打好的框架服务包复制到/usr/local/app/tars/，然后解压，如下：
  cp build/framework.tgz /usr/local/app/tars/
  cd /usr/local/app/tars
  tar xzfv framework.tgz
  
  # 修改各个服务对应conf目录下配置文件，注意将配置文件中的ip地址修改为本机ip地址，如下：
  cd /usr/local/app/tars
  sed -i "s/192.168.2.131/${your_machine_ip}/g" `grep 192.168.2.131 -rl ./*`
  sed -i "s/db.tars.com/${your_machine_ip}/g" `grep db.tars.com -rl ./*`
  sed -i "s/registry.tars.com/${your_machine_ip}/g" `grep registry.tars.com -rl ./*`
  sed -i "s/web.tars.com/${your_machine_ip}/g" `grep web.tars.com -rl ./*`
  
  # 然后在/usr/local/app/tars/目录下，执行脚本，启动tars框架服务
  chmod u+x tars_install.sh
  ./tars_install.sh
  
  # **注意，上面脚本执行后，看看rsync进程是否起来了，若没有看看rsync使用的配置中的ip是否正确（即把web.tars.com替换成本机ip）
  /usr/local/app/tars/tarspatch/util/init.sh
  
  
  #########################################
  在管理平台上面配置tarspatch，注意需要配置服务的可执行目录(/usr/local/app/tars/tarspatch/bin/tarspatch)
  
  在管理平台上面配置tarsconfig，注意需要配置服务的可执行目录(/usr/local/app/tars/tarsconfig/bin/tarsconfig)
  
  tarsnode需要配置监控，避免不小心挂了以后会启动，需要在crontab里面配置
  
  * * * * * /usr/local/app/tars/tarsnode/util/monitor.sh
  
  #########################################
  ````

* 安装Web管理系统

  ````
  # 修改配置文件，文件存放的路径在web/src/main/resources/目录下
  修改 app.config.properties
  # 数据库(db_tars)
  tarsweb.datasource.tars.addr={$your_db_ip}:3306
  tarsweb.datasource.tars.user=tars
  tarsweb.datasource.tars.pswd=tars2015
  # 发布包存储路径
  upload.tgz.path=/usr/local/app/patchs/tars.upload/
  
  vim tars.conf
  替换registry1.tars.com，registry2.tars.com为实际IP。可以只配置一个地址，多个地址用冒号“:”连接
  <tars>
      <application>
          #proxy需要的配置
          <client>
              #地址
              locator = tars.tarsregistry.QueryObj@tcp -h registry1.tars.com -p 17890:tars.tarsregistry.QueryObj@tcp -h registry2.tars.com -p 17890
              sync-invoke-timeout = 30000
              #最大超时时间(毫秒)
              max-invoke-timeout = 30000
              #刷新端口时间间隔(毫秒)
              refresh-endpoint-interval = 60000
              #模块间调用[可选]
              stat = tars.tarsstat.StatObj
              #网络异步回调线程个数
              asyncthread = 3
              modulename = tars.system
          </client>
      </application>
  </tars>
  
  # 打包，在web目录下执行命令，会在web/target目录下生成tars.war
  mvn clean package
  
  #web发布 将tars.war放置到/usr/local/resin/webapps/中
  
  **** 注意：需要将pom.xml中59行、81行中qq-cloud-central 改为 com.tencent.tars
  cp ./target/tars.war /usr/local/resin/webapps/
  
  # 创建日志目录
  mkdir -p /data/log/tars
  
  # 修改Resin安装目录下的conf/resin.xml配置文件 将默认的配置
  <host id="" root-directory=".">
  # 改为<web-app id="/" document-directory="webapps/tars"/>
      <web-app id="/" root-directory="webapps/ROOT"/> 
  </host>
  
  # 启动resin
  /usr/local/resin/bin/resin.sh start
  
  ````

> 要么关闭防火墙
>
> 要么开启指定端口
>
> 注意阿里云安全组设置




* 启动总结

  ````
  service mysql start
  /usr/local/app/tars/tars_install.sh
  /usr/local/app/tars/tarspatch/util/init.sh
  /usr/local/app/tars/tarsnode/bin/tarsnode --config=/usr/local/app/tars/tarsnode/conf/tarsnode.conf
  /usr/local/resin/bin/resin.sh start
  
  ````

*  正常启动进程服务如下

  ````
  [root@centos data]# ps -ef|grep tars
  root       5495      1  0 11:35 pts/0    00:00:03 /usr/local/app/tars/tarsregistry/bin/tarsregistry --config=/usr/local/app/tars/tarsregistry/conf/tarsregistry.conf
  root       5504      1  0 11:35 pts/0    00:00:01 /usr/local/app/tars/tarsAdminRegistry/bin/tarsAdminRegistry --config=/usr/local/app/tars/tarsAdminRegistry/conf/adminregistry.conf
  root       5514      1  0 11:35 pts/0    00:00:02 /usr/local/app/tars/tarsconfig/bin/tarsconfig --config=/usr/local/app/tars/tarsconfig/conf/tarsconfig.conf
  root       5523      1  0 11:35 pts/0    00:00:01 /usr/local/app/tars/tarspatch/bin/tarspatch --config=/usr/local/app/tars/tarspatch/conf/tarspatch.conf
  root       5610      1  0 11:35 ?        00:00:00 rsync --address=192.168.222.132 --daemon --config=/usr/local/app/tars/tarspatch/conf/rsync.conf
  root       5621      1  2 11:35 ?        00:00:18 /usr/local/app/tars/tarsnode/bin/tarsnode --config=/usr/local/app/tars/tarsnode/conf/tarsnode.conf
  root       6021   5621  0 11:36 ?        00:00:05 /usr/local/app/tars/tarsnode/data/tars.tarslog/bin/tarslog --config=/usr/local/app/tars/tarsnode/data/tars.tarslog/conf/tars.tarslog.config.conf
  root       6022   5621  0 11:36 ?        00:00:05 /usr/local/app/tars/tarsnode/data/tars.tarsnotify/bin/tarsnotify --config=/usr/local/app/tars/tarsnode/data/tars.tarsnotify/conf/tars.tarsnotify.config.conf
  root       6054   5621  0 11:36 ?        00:00:03 /usr/local/app/tars/tarsnode/data/tars.tarsqueryproperty/bin/tarsqueryproperty --config=/usr/local/app/tars/tarsnode/data/tars.tarsqueryproperty/conf/tars.tarsqueryproperty.config.conf
  root       6108   5621  0 11:36 ?        00:00:03 /usr/local/app/tars/tarsnode/data/tars.tarsquerystat/bin/tarsquerystat --config=/usr/local/app/tars/tarsnode/data/tars.tarsquerystat/conf/tars.tarsquerystat.config.conf
  root       6163   5621  0 11:37 ?        00:00:04 /usr/local/app/tars/tarsnode/data/tars.tarsstat/bin/tarsstat --config=/usr/local/app/tars/tarsnode/data/tars.tarsstat/conf/tars.tarsstat.config.conf
  root       7097   5621  0 11:42 ?        00:00:01 /usr/local/app/tars/tarsnode/data/tars.tarsproperty/bin/tarsproperty --config=/usr/local/app/tars/tarsnode/data/tars.tarsproperty/conf/tars.tarsproperty.config.conf
  ````

  



