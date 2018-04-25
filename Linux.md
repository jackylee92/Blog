## Linux

> 整理记录平时常用难记Linux命令

* whereis 命令名：搜索命令所在的路径及帮助文档所在的位置;

* whereis les_release

* which 文件名：搜索文件所在的路径及别名

* which ls

* lsb_release -a:查看系统版本信息；

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