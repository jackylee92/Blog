### 安装kibana
* 添加静项源

````
vim /etc/yum.repos.d/kibana.repo 
[kibana-5.x] 
name=Kibana repository for 5.x packages 
baseurl=https://artifacts.elastic.co/packages/5.x/yum 
gpgcheck=1 
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
````

* 测试静项源是否可用

````
yum makecache
````

* 安装

````
yum install kibana
````

* kibana配置

````
vim /etc/kibana/kibana.yml
 server.port: 5601
server.host: "服务器IP"
server.name: "lijundong"
elasticsearch.username: "lijundong"
elasticsearch.password: "lijundong"
````

* 启动

````
systemctl restart kibana
````
