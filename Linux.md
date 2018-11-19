[TOC]
# Linux

## 命令
> 整理记录平时常用难记Linux命令

* whereis 命令名：搜索命令所在的路径及帮助文档所在的位置;

* whereis les_release

* which 文件名：搜索文件所在的路径及别名

* which ls

* lsb_release -a:查看系统版本信息； yum install -y redhat-lsb

* uname -a:查看服务器版本信息；

* /proc/upuinfo:服务器CPU信息；

* more /proc/cpuinfo | grep “model name” 查看服务器CPU型号；

* free:查看内存信息；

* total:所有内容；

* userd:已用内存;free:空闲内存;

* shared:多个进程共享的内存总额;

* buff/cache:磁盘缓存的大小;

* lsof -i tcp:端口:查看端口占用情况；

* netstat -ntlp:列出所有端口 yum install net-tools

 * -a ：all，表示列出所有的连接，服务监听，Socket资料

 * -t ：tcp，列出tcp协议的服务

 * -u ：udp，列出udp协议的服务

 * -n ：port number， 用端口号来显示

 * -l ：listening，列出当前监听服务

 * -p ：program，列出服务程序的PID

* ps -ef :查看服务器进程状态；

* ps 1111:查看1111进程情况；

* hostname -i:查看ip

* find .|xargs grep -ri "IBM" 查询所有文件中内容

* route -n 查看网络配置

* 清空文件夹中所有文件内容

  ````
  find . -type f -exec cp /dev/null {} \;
  ````


## 快捷键：

* Ctrl+a 跳转命令行首
* Ctrl+e 跳转命令行尾
* Ctrl+l 清屏
* Ctrl+u 删除光标至行首中所有
* Ctrl+k 删除光标至行尾中所有

## shell
* 本地IP
  ````
  local_ip=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/'`
  ````
* 当前时间

  ````
  date "+%Y%m%d%H%M%S"
  ````


## 设置

* 超时退出

  ````
  1.修改sshd_config文件 
  vim /etc/ssh/sshd_config 
  ClientAliveInterval 0 修改保持连接时间， 
  ClientAliveCountMax 3 修改保持连接次数。 
  说明： 保持连接为60(秒)，尝试连接数为3(次):表明每隔1分钟触发一次连接，3次连续失败后，自动断开连接
  ````

  ````
  2.设置ssh超时断连 
  vim /etc/profile 
  在 
  HOSTNAME 
  HISTIZE 
  后追加timeout超时时间 
  MOUT=300；300表示超过300秒无操作即断开连接。
  ````

  ````
  #/etc/init.d/sshd restart   #重启sshd服务开启自动启动
  ````

## 开机启动设置

### 方法一：

````
[root@localhost ~]# systemctl enable docker
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
````

### 方法二：

* 编写脚本 vim  /etc/init.d/mount.sh

  ````
  #!/bin/sh
  /usr/bin/vmhgfs-fuse .host:/ /mnt/win -o subtype=vmhgfs-fuse,allow_other
  ````

* 修改脚本权限 chmod u+x  /etc/init.d/mount.sh

* 将服务添加到启动项中 vim /etc/rc.d/rc.local

  ````
  #!/bin/bash
  # THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
  #
  # It is highly advisable to create own systemd services or udev rules
  # to run scripts during boot instead of using this file.
  #
  # In contrast to previous versions due to parallel execution during boot
  # this script will NOT be run after all other services.
  #
  # Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
  # that this script will be executed during boot.
  
  touch /var/lock/subsys/local
  
  # 添加在脚本路径
  /etc/rc.d/init.d/mount.sh
  ````

* 确保 /etc/rc.d/rc.local 权限是可执行，如果不是 执行

  ````
  chmod u+x /etc/rc.d/rc.local
  ````
