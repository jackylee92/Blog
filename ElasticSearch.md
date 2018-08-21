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
  //速度较慢，就是用国内镜像 npm install -g cnpm --registry=https://registry.npm.taobao.org
  √√√
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

### 结构
我们首先要做的是存储员工数据，每个文档代表一个员工。在Elasticsearch中存储数据的行为就叫做**索引(indexing)**，不过在索引之前，我们需要明确数据应该存储在哪里。

在Elasticsearch中，文档归属于一种**类型(type)**,而这些类型存在于**索引(index)**中，我们可以画一些简单的对比图来类比传统关系型数据库：

```
Relational DB -> Databases -> Tables -> Rows -> Columns
Elasticsearch -> Indices   -> Types  -> Documents -> Fields
```



###高亮我们的搜索

很多应用喜欢从每个搜索结果中**高亮(highlight)**匹配到的关键字，这样用户可以知道为什么这些文档和查询相匹配。在Elasticsearch中高亮片段是非常容易的。

让我们在之前的语句上增加`highlight`参数：

```
GET /megacorp/employee/_search
{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing"
        }
    },
    "highlight": {
        "fields" : {
            "about" : {}
        }
    }
}
```

 当我们运行这个语句时，会命中与之前相同的结果，但是在返回结果中会有一个新的部分叫做`highlight`，这里包含了来自`about`字段中的文本，并且用`<em></em>`来标识匹配到的单词。

```
{
   ...
   "hits": {
      "total":      1,
      "max_score":  0.23013961,
      "hits": [
         {
            ...
            "_score":         0.23013961,
            "_source": {
               "first_name":  "John",
               "last_name":   "Smith",
               "age":         25,
               "about":       "I love to go rock climbing",
               "interests": [ "sports", "music" ]
            },
            "highlight": {
               "about": [
                  "I love to go <em>rock</em> <em>climbing</em>" <1>
               ]
            }
         }
      ]
   }
}
```