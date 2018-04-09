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

* 安装
 
````
yum install kibana
````

###安装elasticsearch
__添加静项源__

````
vim /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
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
yum install elasticsearch
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
systemctl restart elasticsearch
````

* elasticsearch 配置

````
cluster.name:  elasticsearch
#这是集群名字，我们 起名为 elasticsearch
#es启动后会将具有相同集群名字的节点放到一个集群下。

node.name: "es-node1"
#节点名字。

discovery.zen.minimum_master_nodes: 2
#指定集群中的节点中有几个有master资格的节点。
#对于大集群可以写3个以上。

discovery.zen.ping.timeout: 40s

#默认是3s，这是设置集群中自动发现其它节点时ping连接超时时间，
#为避免因为网络差而导致启动报错，我设成了40s。

discovery.zen.ping.multicast.enabled: false
#设置是否打开多播发现节点，默认是true。

network.bind_host: 192.168.137.100
#设置绑定的ip地址，这是我的master虚拟机的IP。

network.publish_host: 192.168.137.100
#设置其它节点和该节点交互的ip地址。

network.host: 192.168.137.100
#同时设置bind_host和publish_host上面两个参数。

discovery.zen.ping.unicast.hosts: ["192.168.137.100",  "192.168.137.101","192.168.137.100：9301"]
#discovery.zen.ping.unicast.hosts:["节点1的 ip","节点2 的ip","节点3的ip"]
#指明集群中其它可能为master的节点ip,
#以防es启动后发现不了集群中的其他节点。
#第一对引号里是node1，默认端口是9300,
#第二个是 node2 ，在另外一台机器上,
#第三个引号里是node3，因为它和node1在一台机器上，所以指定了9301端口。
````