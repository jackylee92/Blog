[TOC]

# Alpine

## 安装

下载Alpine光盘

进入光盘执行启动命令 ``setup-alpine``设置网关等信息

alpine1.jpg

如果apk update出错 修改apk镜像地址

``apk update``

``apk upgrade``

``apk add  —no-cache base``

是root用户可ssh登录

​	``vi /etc/ssh/sshd_config``

``PermitRootLogin yes``

``service sshd restart``