# Linux防火墙

> 对于服务器安全整理了firewall和iptables；介绍两种区别，和使用方式；

__firewall__

> firewall centos7 中自带的防火墙,下面是firewall命令实用80%

````
firewall-cmd –version：查看firewall版本；
firewall-cmd –help：查看帮助；
firewall-cmd –state：查看firewall状态；
firewall-cmd –zone=public -list-ports：查看所有打开的端口；
firewall-cmd –get-active-zones：查看区域信息；
firewall-cmd –reload：更新防火墙规则；
firewall-cmd –zone=public –add-port=80/tcp –permanent (–permanent 永久生效，没有此参数重启后失效)
firewall-cmd –zone=public –remove-port=80/tcp –permanent
firewall-cmd –zone=public –queay-port=80/tcp
````

__iptables__

> 下面是iptables命令,实用80%

````
yum install iptables-services：安装iptables
systemctl status iptables：查看iptables状态；
systemctl stop iptables：关闭iptables;
systemctl start iptables：开启iptables;
systemctl restart iptables：重启iptables;
````

> 取消firewall使用iptables

````
systemctl mask firewalld.service：取消使用firewall规则;
systemctl disable firewalld.service：使用iptables规则;

systemctl enable iptables：使用iptables规则;
systemctl enable ip6tables：启用ip6tables规则
````