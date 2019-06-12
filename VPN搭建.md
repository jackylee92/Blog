

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
    "local_address": "127.0.0.1",
    "local_port":1080,
    "port_password" : {
        "444" : "password"
    },
    //"password":"*******",
    //"server_port":444,
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}

````
* 重启shadowsocks
````
ssserver -c /etc/shadowsocks.json -d start
````

* 下载ShadowsocksX app

* 配置服务
![配置](https://github.com/jackylee92/Blog/blob/master/Images/vpnconfig.jpg?raw=true)
* 打开google测试
````
www.google.com
````