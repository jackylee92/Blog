# Manjaro

## 系统安装

### 系统：

* 电脑：宏基
* 内存：8G
* CPU：i5-8250U
* 固态硬盘：500G
* U盘：16G
* 系统：[Manjaro KDE](https://manjaro.org/downloads/official/kde/) 
* 制作U盘启动程序工具：[rufus](https://links.jianshu.com/go?to=http%3A%2F%2Frufus.akeo.ie%2F)

## 环境配置

### 制作启动盘

使用rufus制作启动盘，制作后U盘只有4M左右。

### 修改bois

插入U盘

启动电脑，一直按F2进入bios

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/bois-image.JPG?raw=true)

设置``Boot``中``Boot Mode``为UEFI，一般原本就是UEFI，则可以不用设置。

<image bois-boot-mode-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/bois-boot-mode-image.JPG?raw=true)

关闭Secure Boot：进入Boot菜单，修改``Secure Boot``为``Disabled``，如果不可以选择，则进入``Security``菜单，选择``Set Supervisor Password``回车添加密码，可以先设置简单的，然后F10重启，在通过F2输入设置的密码进入bois然后可以设置``Boot``中``Secure Boot``了；如果方法行不通，则可以网上对应电脑查一下关闭``Secure Boot``方式。

<image bois-security-set-supervisor-password-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/bois-security-set-supervisor-password-image.JPG?raw=true)

设置Boot中``Boot priority order`` 第一个启动项为USB，选中USB按F6移动位置。

<image bois-boot-priority-order-usb-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/bois-boot-priority-order-usb-image.JPG?raw=true)

按F10保存重启。

### 安装系统

上面按F10保存重启后，会进入Manjaro安装初始页面，此时按一下上下，避免自动进入安装下一步；

第一项 tz=UTC：表示时区，回车进入选择，选择Asia=>Shanghai

第二项 keytable=us：此项不需要调整；

第三项 lang=en_US: 表示安装时语言：回车进入选择，选择最后一项中文=》lang=zh_CN

第四项 driver=free: 驱动，分别为开源、非开源，此项不需要调整

第五项 Boot: 选中按e进入修改，修改driver值由``free``改为``intel`` 紧跟着后面 nouveau.modeset值有1改为0

<image install-manjaro-init-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-init-image.JPG?raw=true)

<image install-manjaro-init-set-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-init-set-image.JPG?raw=true)

然后按F10进入安装。

<image install-manjaro-welcome-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-welcome-image.JPG?raw=true)

点击右下角WiFi连接网络

然后点击``Launch install`` 开始安装

<image install-manjaro-set1-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set1-image.JPG?raw=true)

下一步，选择位置，点击上海

<image install-manjaro-set2-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set2-image.JPG?raw=true)

下一步，选择键盘，默认不需要修改

<image install-manjaro-set3-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set3-image.JPG?raw=true)

下一步，设置分区

可以选择抹除磁盘，将manjaro安装在整个系统中，会自动分区为一个300M的引导分区，一部分隐藏分区，其他全部为系统分区

<image install-manjaro-se4-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-se4-image.JPG?raw=true)

我选择的是手动分区

<image install-manjaro-set5-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set5-image.JPG?raw=true)

选择500G固态硬盘，下面的是U盘

<image install-manjaro-set6-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set6-image.JPG?raw=true)

点击“新建分区表”选择 “GUID分区表(GPT)”，将清空分区设置，准备重新开始建立分区

<image install-manjaro-set7-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set7-image.JPG?raw=true)

> 建立引导分区，默认建立的是300M，我给了512M应该够了，文件系统：fat32 挂载点：/boot/efi 标记：boot

<image install-manjaro-set8-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set8-image.JPG?raw=true)

> 建立opt分区，一般安装三方软件存放地，50G应该够了，文件系统：ext4 挂载点：/opt 标记：无

<image install-manjaro-set9-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set9-image.JPG?raw=true)

> 建立系统分区，50G够用了，文件系统：ext4 挂载点：/ 标记：无

<image install-manjaro-set10-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set10-image.JPG?raw=true)

> 建立临时存储空间，该空间在系统关机、异常时数据临时存储的地方，16G完全够用了，应该小于等于系统内存8G即可，文件系统：linuxswap 挂载点：无 标记：无

<image install-manjaro-set11-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set11-image.JPG?raw=true)

> 建立用户家目录分区，该空间保存用户数据，文件系统：ext4 挂载点：/home 标记：无

<image install-manjaro-set12-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-set12-image.JPG?raw=true)

> 预留10个G以备不时之需

下一步，创建用户

<image install-manjaro-create-user-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-create-user-image.JPG?raw=true)

下一步，选择安装的程序。可以先不安装，这样系统安装的比较快

<image install-manjaro-app-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-app-image.JPG?raw=true)

下一步，摘要。查看安装的所有信息。

<image install-manjaro-info-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-info-image.JPG?raw=true)

下一步，点击安装，进入安装中页面。

<image install-manjaro-start-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-start-image.JPG?raw=true)

大约二十分钟后。。。。安装完成。勾选重启，点击完成；

等电脑关机后就可以拔出U盘了。

此时系统安装完成。

<image install-manjaro-success-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/install-manjaro-success-image.JPG?raw=true)

## 环境配置

初次进入系统

<image set-manjaro-welcome-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/set-manjaro-welcome-image.JPG?raw=true)

取消"Launch at start" 然后关闭

点击右下角WiFi连接

### 程序安装

__pacman：官方包管理工具__

* 更改pacman镜像源为国内

````
sudo pacman-mirrors -m rank -c China
````

* 录屏软件(选装)

````
sudo pacman -Sy simplescreenrecorder
````

* yay

第三方包管理工具，使用科学上网后下载国外程序更快

````
sudo pacman -Sy yay
````

> 查看已安装程序：yay -Qs xxx
>
> 搜索包：yay -Ss xxx
>
> 删除程序和程序依赖：yay -Rsn xxx

* 科学上网

安装shadowsocks、polipo

````
yay -Sy shadowsocks-libev
yay -Sy polipo
````

使用root用户添加配置文件

````
su
mkdir /etc/shadowsocks
vi /etc/shadowsocks/coreja.json
cp /etc/polipo/config.simple /etc/polipo/config
vi /etc/polipo/config
````

shadowsocks : vi /etc/shadowsocks/coreja.json

````
{
    "server" : "string 根据自己代理服务器填写",
    "server_port" : " int 根据自己代理服务器填写",
    "local_address" : "127.0.0.1",
    "local_port" : 1080,
    "password" : "string 根据自己代理服务器填写",
    "timeout" : 300,
    "method" : "aes-256-gcm 根据自己代理服务器填写",
    "fast_open" : true
}
````

polipo : vi /etc/polipo/config

````
17: proxyAddress = "::0"
19: proxyPort = 1081

41: sockesParentProxy = "localhost:1080"
42: socksProsyType = socks5
````

启动

````
# 开启 shadowsocks-libev
sudo systemctl start shadowsocks-libev@coreja.service
# 开机自动启动 shadowsocks-libev
sudo systemctl enable shadowsocks-libev@coreja.service
# 开启 polipo
sudo systemctl start polipo
# 开机自动启动 polipo
sudo systemctl enable polipo
````

测试

````
export http_proxy = "localhost:1081"
export https_proxy = "localhost:1081"
curl www.google.com
# 输出：google 的html代码
````

> 一般这样就可以科学上网了，后面针对不同的程序需要设置代理。

<image set-manjaro-google-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/set-manjaro-google-image.JPG?raw=true)

firefox代理，设置如下：

<image set-manjaro-firefox-image>

![1535040986682](https://raw.githubusercontent.com/jackylee92/file/master/manjaro/set-manjaro-firefox-image.JPG?raw=true)

* 输入法

打开“添加/删除软件”，搜索"IBus"，选中第一个，然后选在“ibus pinyin”，选择第一个或者 "sunpinyin"选择安装，然后点应用，开始下载安装。

<image set-manjaro-input-image1>

<image set-manjaro-input-image2>

添加文件.xprofile

vi ~/.xprofile

````
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -x -d
````

然后重启

* Chrome

````
yay -Sy google-chrome
中间 选择第一个google-chrome
````

* zsh

````
yay -Sy oh-my-zsh-git
````

修改终端模式使用zsh，设置=>配置Konsole=>配置方案=>选中编辑=>修改命令``/bin/zsh``

* neovim

````
yay -Sy neovim
````

* git 安装上面程序依赖git，所以此时git肯定已经安装了

````
yay -Sy git
````

* neofetch 显示终端信息

````
yay -Sy neofetch
````

* 微信

打开“添加/删除软件”=>首选项=>启用ARU支持，然后搜索"deepin-wine-ewchat" 安装

问题：可以发送文件，但是截图和图片无法发送，但再重新登录了几次后又莫名其妙可以发送了。 
* 截图

 系统自带

> 后面程序暂未安装，可以通过Chrome完成的，就不安装。毕竟大部分程序多多少少会有些兼容性问题。

* QQ：不使用了
* 百度网盘：chrome可以代理
* navicate：终端命令行代理
* wps：未装
* googkeep：未装
* postman：终端curl可以代替
* docker：``yay -Sy docker``
  * PHP
  * Golang
  * Nginx
  * MySQL
* 迅雷：未装
* goland：未装，先使用nvim
* phpstorm：未装
* 音乐：未装
* office：系统自带，不过感觉用的不是很舒服，可以在“添加/删除程序”中搜索到然后安装
