# VMware 虚拟机 CentOs

##  设置虚拟机共享

* 关闭虚拟机
* 右击虚拟机名称，点击设置，点击选项，共享文件夹总是开启，选择需要共享的目录，保存；

## CentOs设置安装软件

* 创建cdrom文件夹

````
mkdir /mnt/cdrom
````

* 挂载

````
mount /dev/cdrom /mnt/cdrom
cp /mnt/cdrom/VMwareTools-10.1.15-6627299.tar.gz /opt/
cd /opt/
tar -zxvf VMwareTools-10.1.15-6627299.tar.gz
cd vmware-tools-upgrader-64
./vmware-install.pl
回车....
回车...
回车..
回车.
...
..
.
mount -t vmhgfs .host:/  /mnt/hgfs
ERROR:cannot mount filesystem: No such device
yum install open-vm-tools-devel -y
有的源的名字并不一定为open-vm-tools-devel(centos) ，而是open-vm-dkms(unbuntu)
执行：/usr/bin/vmhgfs-fuse .host:/ /mnt/win -o subtype=vmhgfs-fuse,allow_other
cd /mnt/hgfs
````

* 软链

````
ln -s /home/cloud-user/win ./
````

* 查看挂载点

````
df -h
````



## 静态IP

* 笔记本centos 

  ifconfig查看网卡 一般为 enp3s0

  Vim /etc/sysconfig/network-scripts/ifcfg-enp3s0

````
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp3s0
UUID=89d3d311-8ecc-474c-9dbe-8ffacb8c5979
DEVICE=enp3s0
# 以下参数需要注意
ONBOOT=yes
BOOTPROTO=static
# 分配的IP
IPADDR0=192.168.1.1
PREFIXO0=24
# 网关
GATEWAY0=192.168.40.2
# 一般都有用
DNS1=8.8.8.8
DNS2=114.114.114.114
````

* 虚拟机centos

````
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
#BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=94e31b66-67f7-42e7-9c72-0770691f4fd9
DEVICE=ens33
# 以下参数需要注意
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.1.1
NETMASK=255.255.255.0
GATEWAY=192.168.40.2
DNS1=119.29.29.29
````

* 重启网络 systemctl restart network
* ping www.baidu.com





## Parallels Centos共享文件夹

* CD/DVD 选择 pro-tools-lin.iso
* 重启虚拟机，安装Parallels Tools -> 确定 -> 无论如何
* 建立文件夹 ``mkdir -p /media/cdrom``
*  挂载``mount /dev/cdrom /media/cdrom/`` 提示 ``mount: /dev/sr0 写保护，将以只读方式挂载``
* ``/media/cdrom/install``
* 如果安装失败 提示error 查看日志 ``tail -f /var/log/parallels-tools-install.log``
* 安装成功后在``/media/psf``中可看见共享的目录，共享目录在设置中须先设置好
* 建立软链 ``ln -s /media/cdrom/Home /mac``