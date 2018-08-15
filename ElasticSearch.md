# ElasticSearch

## 安装

> 不可用root用户操作，必须使用普通用户，且下载解压的所有文件所属用户为普通用户；

* 下载 ( 官网：https://www.elastic.co/downloads/elasticsearch)

  ````
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.zip
  ````

* 解压、安装

  ````
  unzip elasticsearch-6.3.2.zip
  cd elasticsearch-6.3.2 
  bin/elasticsearch
  ````

> org.elasticsearch.bootstrap.StartupException: java.lang.RuntimeException: can not run elasticsearch as root。  
>
> 解决方案：不可用root操作，切换普通用户chown 普通用户:普通用户组 elasticsearch-6.3.2 -R  再bin/elasticsearch

* 配置

  * 修改elasticsearch.yml，增加跨域的配置(需要重启es才能生效)

    ````
    http.cors.enabled: true
    http.cors.allow-origin: "*"
    ````

  * 配置参考：https://www.cnblogs.com/xiaochina/p/6855591.html

* 验证

  ````
  curl http://localhost:9200
  ````

* ERROR

  * [1]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536].      

    > 原因：这个问题比较常见，原因是因为最大虚拟内存太小   
    > 解决方案：切换到root用户，编辑limits.conf配置文件，运行：vi /etc/security/limits.conf添加如下内容(备注：* 代表Linux所有用户名称（比如 hadoop）保存、退出、重新登录才可生效。)：   
    ````
    * soft nofile 131072
    * hard nofile 131072
    * soft nproc 2048
    * hard nproc 4096 
    ````

  * [2]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144].     
    > 原因：无法创建本地文件问题，用户最大可创建文件数太小    
    > 解决方案：切换到root用户下，修改配置文件sysctl.conf，vi /etc/sysctl.conf添加下面配置： vm.max_map_count=655360，并执行命令：sysctl -p，然后重新启动Elasticsearch，即可启动成功。
    ````
     vm.max_map_count=655360
    ````

  

## 安装elasticsearch-head插件

> elasticsearch-head是个用来与Elasticsearch互动的图形化界面插件，有了他你可以很方便的管理你的Elasticsearch，查看你的Elasticsearch状态或者测试你的查询语句。这个是他官方的`GitHub页面`。

* 安装(使用普通用户)

  ````
  git clone git://github.com/mobz/elasticsearch-head.git
  cd elasticsearch-head
  npm install
  npm run start
  ````

  > WARN 警告可以暂忽略

* 修改配置： vim Gruntfile.js 添加hostname : '${ip}'

  ````
  connect: {
          server: {
                  options: {
                          hostname: '0.0.0.0',
                          port: 9100,
                          base: '.',
                          keepalive: true
                  }
          }
  }
  ````

  

* 安装完成后用http://localhost:9100/ 打开即可。

  

__中文文档__:https://es.xiaoleilu.com/

__安装参考__:https://www.marsshen.com/2018/04/23/Elasticsearch-install-and-set-up/



## 使用

