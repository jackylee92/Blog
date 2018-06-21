## Mysql编译安装

* 下载安装包 例如 

  ````
  wget http://........./mysql-5.6.25.tar
  ````

* 解压安装包 

  ````
  tar -zxvf mysql-5.6.25.tar
  ````

* 编译安装

  ````
  # cmake 编译安
  cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.6.25 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
  
  make
  
  make install
  ````

* 修改权限

  ````
  cd /use/local/mysql-5.6.25/
  
  chown -R mysql:mysql /usr/local/mysql-5.6.25/
  ````

* 执行初始化配置脚本，创建系统自带的数据库和表

  ````
  scripts/mysql_install_db --basedir=/usr/local/mysql-5.6.25/ --datadir=/usr/local/mysql-5.6.25/data --user=mysql
  
  vim my.cnf  
  ````

* 将添加服务，拷贝服务脚本到init.d目录，并设置开机启动

  ````
  cp support-files/mysql.server /etc/init.d/mysql
  ````

* 并设置开机启动
  ````
  chkconfig mysql on
  ````

* 启动
  ````
  systemctl start mysql
  ````

  

> 在启动MySQL服务时，会按照一定次序搜索my.cnf，先在/etc目录下找，找不到则会搜索"$basedir/my.cnf"，在本例中就是 /usr/local/mysql/my.cnf，这是新版MySQL的配置文件的默认位置！