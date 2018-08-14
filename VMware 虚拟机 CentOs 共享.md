# VMware 虚拟机 CentOs 共享

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
  执行：vmhgfs-fuse .host:/ /mnt/hgfs
  cd /mnt/hgfs
  ````

* 软链

  ````
  ln -s /home/cloud-user/win ./
  ````

  