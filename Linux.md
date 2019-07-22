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

* lsof -i tcp:端口:查看端口占用情况； yum install lsof -y

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

* ls  -lhtS 当前目录下文件显示大小并排序

* 清空文件夹中所有文件内容

  ````
  find . -type f -exec cp /dev/null {} \;
  ````

* 查看当前目录下所有文件夹大小

  ````
  du -sh * | sort -n 从小到大
  df -i //查看磁盘空间详情
  du -sh * | sort -nr 从大到小
  du -sh .[!.]* * | sort -nr 带隐藏文件的排序
  ````

* grep 文件内容上下文

````
grep -C 5 foo file  显示file文件中匹配foo字串那行以及上下5行

grep -B 5 foo file  显示foo及前5行

grep -A 5 foo file  显示foo及后5行
````

* Top -p 进程ID 查看某一进程内存使用情况

> **VIRT：virtual memory usage 虚拟内存**1、进程“需要的”虚拟内存大小，包括进程使用的库、代码、数据等
> 2、假如进程申请100m的内存，但实际只使用了10m，那么它会增长100m，而不是实际的使用量
>
> **RES：resident memory usage 常驻内存**
> 1、进程当前使用的内存大小，但不包括swap out
> 2、包含其他进程的共享
> 3、如果申请100m的内存，实际使用10m，它只增长10m，与VIRT相反
> 4、关于库占用内存的情况，它只统计加载的库文件所占内存大小
>
> **SHR：shared memory 共享内存**
> 1、除了自身进程的共享内存，也包括其他进程的共享内存
> 2、虽然进程只使用了几个共享库的函数，但它包含了整个共享库的大小
> 3、计算某个进程所占的物理内存大小公式：RES – SHR
> 4、swap out后，它将会降下来
>
> **DATA**
> 1、数据占用的内存。如果top没有显示，按f键可以显示出来。
> 2、真正的该程序要求的数据空间，是真正在运行中要使用的。

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
  
## 时间错误

  ````
  yum install -y ntpdate
  ntpdate us.pool.ntp.org
  ````

  
