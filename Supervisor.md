> 脚本监控、定时监测脚本、停止、启动程序

### Supervisor
* 安装

````
pip install supervisor
echo_supervisord_conf > /etc/supervisord.conf
cd /etc
mkdir supervisord.conf.d
````

* 新建配置文件 vim php-c.ini

````
; 服务别名
[program:test]
; 脚本命令 守护进程命令
command=nohup ./run.sh >> log.log &
; 脚本日志
stdout_logfile=/opt/php-c.log
; 自动启动
autostart=true
; 自动重启
autorestart=true
; 监测间隔
startsecs=5
; 优先级
priority=1
; 操作停止进程下面的所有子进程，避免产生孤儿进程
stopasgroup=true
; 类似上面，只是干掉
killasgroup=true
; 脚本的位置
directory=/home/jacky/mac/Project/zhaoyouwang/sh
````

* 停止supervisor

````
killall supervisor
````

* 启动supervisor

````
supervisord -c /etc/supervisord.conf
````
* 重启supervisor中某一个服务

````
# 进入supervisor客户端
> supervisortl
# 更新配置
> update
# 重启服务
> restart 服务名
# 查看服务log
> tail -f 服务名
````



<delete>

* 一个监控执行多条命令

````
在一个shell脚本中写如多行需要执行的命令
然后在配置中shell执行该脚本
````
</delete>