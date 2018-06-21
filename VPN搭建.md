

### VPN搭建

---
* pid安装
````
yum install python-setuptools && easy_install pip
````
* shadowsocks安装
````
pip install shadowsocks
````
* shadowsocks配置
````
vi /etc/shadowsocks.json
{
    "server":"0.0.0.0",
    "server_port":8388,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"密码",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}
````
* 重启shadowsocks
````
server -c /etc/shadowsocks.json -d start
````

* 下载ShadowsocksX app

* 配置服务
![目录](https://github.com/jackylee92/Blog/blob/master/Images/vpnconfig.jpg?raw=true)
* 打开google测试
````
www.google.com
````