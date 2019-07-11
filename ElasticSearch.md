[TOC]



# ElasticSearch

> es 版本1.0x 、2.0x、5.0x   版本直接从2.0跳到5.0是为了统一elk所有版本
>
> 6版本之前 索引的type可以为多个，6版本的一个索引type只能有一个，7去除type。因为对于es来说type管理是多余了，直接通过索引管理一类数据即可

## 文档：

[动态更新索引](!https://www.elastic.co/guide/cn/elasticsearch/guide/current/dynamic-indices.html#img-index-segments) ：没看懂，主要正对索引数据内存优化讲解

[近实时搜索](!https://www.elastic.co/guide/cn/elasticsearch/guide/current/near-real-time.html)：没看懂，主要正对索引数据内存优化讲解

[查询中缓存使用](!https://www.elastic.co/guide/cn/elasticsearch/guide/current/filter-caching.html)：

## 安装

### Elasticsearch

> 不可用root用户操作，必须使用普通用户，且下载解压的所有文件所属用户为普通用户；
>
> elasticsearch 创建搜索时默认创建5个分片，一个备份

* 下载 ( 官网：https://www.elastic.co/downloads/elasticsearch)

````shell
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.zip
````

* 解压、安装

````shell
unzip elasticsearch-6.3.2.zip
cd elasticsearch-6.3.2 
bin/elasticsearch
````

> org.elasticsearch.bootstrap.StartupException: java.lang.RuntimeException: can not run elasticsearch as root。  
>
> 解决方案：不可用root操作，切换普通用户chown 普通用户:普通用户组 elasticsearch-6.3.2 -R  再bin/elasticsearch

* 配置

  1. 修改elasticsearch.yml，增加跨域的配置(需要重启es才能生效)

  ````
  http.cors.enabled: true
  http.cors.allow-origin: "*"
  ````

  2. cluster.name: 集群名【如果使用集群，多个节点这个属性需要一直】

  3. node.name : 节点名【如果使用集群，多个节点这个属性需要全部不同】

  4. node.master:是否为master (集群使用)【如果使用集群，Master节点此处为true，Slave节点此处为false】

  5. network.host:绑定iP

  6. discovery.zen.ping.unicast.hosts:["集群MasterIP"]　找到master主机iP，【集群salve节点必须设置，master节点不需要设置】

  7. 配置参考：https://www.cnblogs.com/xiaochina/p/6855591.html

* 验证

  ````shell
  curl http://localhost:9200
  ````

#### 安装中ERROR

1. max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536].      

> 原因：这个问题比较常见，原因是因为最大虚拟内存太小 
> 解决方案：切换到root用户，编辑limits.conf配置文件，运行：vi /etc/security/limits.conf添加如下内容(备注：* 代表Linux所有用户名称（比如 hadoop）保存、退出、重新登录才可生效。)：   
````shell
* soft nofile 131072
* hard nofile 131072
* soft nproc 2048
* hard nproc 4096 
````

2. max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144].     

> 原因：无法创建本地文件问题，用户最大可创建文件数太小    
> 解决方案：切换到root用户下，修改配置文件sysctl.conf，vi /etc/sysctl.conf添加下面配置： vm.max_map_count=655360，并执行命令：sysctl -p，然后重新启动Elasticsearch，即可启动成功。
````shell
 vm.max_map_count=655360
````

3. elasticsearch 启动时需要非root用户

   > 报错：(Permission denied) java.io.FileNotFoundException: /srv/elasticsearch/logs/test-es-cluster.log (Permission denied) 
   >
   > 需要给/srv/elasticsearch 目录es用户权限 chown elastic:elastic -R /src/elasticsearch

###  认证插件 x-pack安装

1. 使用es用户进入elastic search/bin 执行``elastixcsearch-plugin install x-pack``

> elasticsearch plugin  Connection refused (Connection refused) 可能是下载插件连接错误，需要代理

2. 直接下载``https://www.elastic.co/guide/en/x-pack/current/index.html``

3. 将对应版本的x-pack.zip放入elasticsearch 所在的服务器上
4. ``elasticsearch-plugin install file:///opt/x-pack.zip`` 注意路径前面加file:// 然后安装提示完成安装
5. ``bin/x-pack/setup-passwords auto`` 生成默认密码
6. 或``bin/x-pack/setup-passwords interactive`` 生成指定密码 如下

> 三个内置用户名 和秘密

````shell
[elastic@test-tars-elasticsearch-91-59-pbs-sh x-pack]$ ./setup-passwords interactive
Initiating the setup of passwords for reserved users elastic,kibana,logstash_system.
You will be prompted to enter passwords as the process progresses.
Please confirm that you would like to continue [y/N]y


Enter password for [elastic]:
Reenter password for [elastic]:
Enter password for [kibana]:
Reenter password for [kibana]:
Enter password for [logstash_system]:
Reenter password for [logstash_system]:
Changed password for user [kibana]
Changed password for user [logstash_system]
Changed password for user [elastic]
[elastic@test-tars-elasticsearch-91-59-pbs-sh x-pack]$
````

### Elasticsearch-head
#### 安装npm

````
$ curl -sL -o /etc/yum.repos.d/khara-nodejs.repo https://copr.fedoraproject.org/coprs/khara/nodejs/repo/epel-7/khara-nodejs-epel-7.repo
$ yum install -y nodejs nodejs-npm
````

* 修改npm 镜像源，下载安装超快：

  ````
  npm config set registry https://registry.npm.taobao.org  npm info underscore
  ````

* 安装 grunt 

  `` npm install -g grunt-cli ``   

  `` npm install grunt``    

* 验证

  `` grunt server   ``    

  ````
  ERROR:
  [root@localhost elasticsearch-head]#    
  >> Local Npm module "grunt-contrib-clean" not found. Is it installed?
  >> Local Npm module "grunt-contrib-concat" not found. Is it installed?
  >> Local Npm module "grunt-contrib-watch" not found. Is it installed?
  >> Local Npm module "grunt-contrib-connect" not found. Is it installed?
  >> Local Npm module "grunt-contrib-copy" not found. Is it installed?
  >> Local Npm module "grunt-contrib-jasmine" not found. Is it installed?
  Warning: Task "connect:server" not found. Use --force to continue.
  ````
  解决：

  ``  npm install grunt-contrib-clean``

  ``    npm install grunt-contrib-concat``     

  依次安装缺少的依赖，完成；


#### 安装Elasticsearch-head

> elasticsearch-head是个用来与Elasticsearch互动的图形化界面插件，有了他你可以很方便的管理你的Elasticsearch，查看你的Elasticsearch状态或者测试你的查询语句。这个是他官方的`GitHub页面`。

1. 安装(使用root用户) 下载去githut搜索elasticsearch-head 选择mobz开头的

````shell
git clone git://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head
npm install
#速度较慢，就是用国内镜像 npm install -g cnpm --registry=https://registry.npm.taobao.org
grunt server
````

> WARN 警告可以暂忽略

2. 修改配置： vim Gruntfile.js 添加hostname : '${ip}'

````shell
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

3. 安装完成后用http://localhost:9100/ 打开即可。

#### 安装中ERROR

  ````shell
> grunt server
sh: grunt: 未找到命令
npm ERR! file sh
npm ERR! code ELIFECYCLE
npm ERR! errno ENOENT
npm ERR! syscall spawn
npm ERR! elasticsearch-head@0.0.0 start: `grunt server`
npm ERR! spawn ENOENT
npm ERR! 
npm ERR! Failed at the elasticsearch-head@0.0.0 start script.
npm ERR! This is probably not a problem with npm. There is likely additional logging output above.
npm WARN Local package.json exists, but node_modules missing, did you mean to install?

npm ERR! A complete log of this run can be found in:
npm ERR!     /root/.npm/_logs/2018-04-21T08_42_24_584Z-debug.log
  ````

  >  解决方案：npm install -g grunt-cli 


__中文文档__:https://es.xiaoleilu.com/

__安装参考__:https://www.marsshen.com/2018/04/23/Elasticsearch-install-and-set-up/




## ES概念

我们首先要做的是存储员工数据，每个文档代表一个员工。在Elasticsearch中存储数据的行为就叫做**索引(indexing)**，不过在索引之前，我们需要明确数据应该存储在哪里。

在Elasticsearch中，文档归属于一种**类型(type)**,而这些类型存在于**索引(index)**中，我们可以画一些简单的对比图来类比传统关系型数据库：

```
Relational DB -> Databases -> Tables -> Rows -> Columns
Elasticsearch -> Indices   -> Types  -> Documents -> Fields
```

每一个index都有一个Mapping来定义该index怎样去索引，需要注意的是，大体概念我们可以这样理解ES中的index和Mapping Type，index 对应SQL DB中的database，Mapping Type对应 SQL DB中的table，但是又不完全一样，因为在SQL DB中，不同table中的字段名称可以重复，但是定义可以不一样，再ES中却不可以存在这种情况，因为ES是基于Lucene,在ES映射到Lucene时，同一个index下面的不同mapping的同一字段名映射是同一个的，也就意味着，再不同的mapping中，相同字段名的类型也要保持一致

分片：每个索引中分片，数据量大的时候分片利于查询；

备份：索引的备份，备份也提供查询功能；

elasticsearch-head概览中方框中的123表示索引的分片 方框比较宽的表示主分片，其他的表示分片的备份，细方框的为对应数字粗方框的分片备份；

![1535040986682](https://github.com/jackylee92/Blog/blob/master/Images/es1.png?raw=true)

索引中_mappings中有字段结构表示结构索引，没有则是非结构话索引；

__elasticsearch 隐藏管理__：分片机制（将数据分摊到不同的分片中）shard机制

__elasticsearch 扩容方案__：（现状：6台服务器，每台1T，需要增长到8T容量）

	垂直扩容：重新购买两台服务器，每台服务器的容量时2T，替换掉老的两套服务器；
	
	水平扩容：新购两台服务器，每台服务器1T,直接加入集群中；

__all_field__ : elasticsearch在创建index的document时会将多个field串连起来成为一个all_field 全局索引搜索没有指定某一个field搜索时会对这个all_field搜索

__exact value__  :在建立倒排索引时，分词时是将整个值一起作为一个关键词建立索引；

__full text__: 在建立倒排索引时，会经历各种处理，拆分词 、同义词转换、大小写转换等；

__keyword__: keyword不会进行分词

__倒排索引:__通过固定的分词方式将文本分成许多不重复的词条，然后标记每个词条所出现的文档；

> https://www.elastic.co/guide/cn/elasticsearch/guide/current/inverted-index.html

__分片/副本__

分片：大量文档时，可分为较小的分片，每个分片都是一个独立的Apache Lucene索引；

- 更多分片使索引能传到更多的服务器，可并行处理更多文件；
- 更多分片导致每个分片的资源量减少，处理效率提高；
- 更多分片会导致搜索是面临更多问题，因为必须从更多分片中合并结果，使得查询的聚合阶段需要更多资源；

> 分片数 视情况而定，默认值是一个不错的选择；

副本：为提高查询的吞吐量或实现高可用可以时用副本，副本是一个分片的精确复制



## ES使用

### 关闭Elasticsearch

* Ctrl+c
* kill -9 进程号
* curl 请求关闭 : curl -XPOST http://localhost:9200/_cluster/nodes/_shutdown
* curl 关闭某一个nod : curl -XPOST http://localhost:9200/_cluster/nodes/节点标识符/_shutdown 

### 创建索引： 

__PUT__:``http://ip:端口/索引(index)``

````json
  {
      "settings【关键词】": {
          "number_of_shards【关键词】": "指定索引的分片数",
          "number_of_replicas【关键词】": "指定索引备份数"
      },
      "mappings【关键词】": {
          "类型名1(type)": {
              "properties【关键词】属性定义集合": {
                  "属性名1": {
                      "type【关键词】类型值": "",
                      "analyzer【关键词】（分词设置）": ""
                  },
                  "属性名2": {
                      "type【关键词】类型值": ""
                  }
              }
          },
          "类型名2(type)": {}
      }
  }
````

  __字段属性详细:__

  ````json
{
    "name": {
        "type": "string //类型",
        "store": "yes //公共属性 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-store.html",
        "index": "not_analyzed  //analyzed:编入索引供搜索、no:不编入索引、not_analyzed(string专有):不经分析编入索引",
        "boost": "1 //文档中该字段的重要性，值越大表示越重要，默认1",
        "null_value": "jim //当索引文档的此字段为空时填充的默认值，默认忽略该字段",
        "include_in_all": "xxx //此属性是否包含在_all字段中,默认为包含",
        "analyzer": "xxx//text特有属性 定义用于索引和搜索的分析器名称,默认为全局定义的分析器名称。可以开箱即用的分析器:standard,simple,whitespace,stop,keyword,pattern,language,snowball",
        "index_analyzer": "xxx //text特有属性 定义用于建立索引的分析器名称",
        "search_analyzer": "xxx //text特有属性 定义用于搜索时分析该字段的分析器名称",
        "ignore_above": "xxx //text特有属性 定义字段中字符的最大值，字段的长度高于指定值时，分析器会将其忽略"
    }
}
  ````

__创建成功：__

````json
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "index": "user"
}
````

__添加已存在的索引返回报错：__

````
{
  "error": {
    "root_cause": [
      {
        "type": "resource_already_exists_exception",
        "reason": "index [user/7sQYbNEnS96DL2K-xi83YA] already exists",
        "index_uuid": "7sQYbNEnS96DL2K-xi83YA",
        "index": "user"
      }
    ],
    "type": "resource_already_exists_exception",
    "reason": "index [user/7sQYbNEnS96DL2K-xi83YA] already exists",
    "index_uuid": "7sQYbNEnS96DL2K-xi83YA",
    "index": "user"
  },
  "status": 400
}
````

### 添加字段

__PUT__:``http://ip:端口/索引(index)/类型(type)/_mapping``

````json
{
    "properties": {
        "newFieldName": {
            "type": "string",
            "index": "not_analyzed"
        }
    }
}
````

__字段不存在或者添加的字段和索引中已经存在的字段结果相同则返回成功：__

````json
{
  "acknowledged": true
}
````

__索引中存在该字段，结构与提交的结构不同则会返回错误：__

````json
{
  "error": {
    "root_cause": [
      {
        "type": "illegal_argument_exception",
        "reason": "mapper [newField] of different type, current_type [text], merged_type [integer]"
      }
    ],
    "type": "illegal_argument_exception",
    "reason": "mapper [newField] of different type, current_type [text], merged_type [integer]"
  },
  "status": 400
}
````

### 插入数据

__POST__ :`` http://ip:端口号/索引名(index)/类型名(type)/文档id(不填es默认会创建)``

> 如果指定ID的数据存在则会更新

````json
{
    "属性名1": "属性值",
    "属性名2": "属性值"
}
````

__成功返回：__

> 添加成功 result值为"created",更新成功"updated"

````json
{
  "_index": "user",
  "_type": "list",
  "_id": "JqBA4GsBgfD8XS4-tiAw",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 0,
  "_primary_term": 1
}
````

### 修改数据

1. __post__:``htpp://ip:端口号/索引名(index)/类型名(type)/文档id/_update【关键词】(指定操作)``

> 在内部，Elasticsearch必须首先获取文档，从_source属性获取数据，删除旧的文件，更改 _source 属性，然后把它作为新的文档来索引，因为信息一但在Lucene中倒排索引中存储就不能再被修改，当并发是，尝试写入一个已经更改的文档将会失败，提示version error版本错误，这是elasticsearch中文档的版本控制功能(乐观锁)

````json
{
    "doc【关键词】": {
        "属性名1": "新的属性值"
    }
}
````

2. __post__:``htpp://ip:端口号/索引名(index)/类型名(type)/文档id/_update【关键词】(指定操作)``

````
{
    "script【关键词】(脚本的方式修改)": {
        "lang【关键词】(指定脚本语言)": " painless【关键词】(es内置的脚本语言,es支持很多中脚本语言js.python等)",
        "inline【关键词】(指定脚本内容)": "ctx._source.age = params.数组key //方式2",
        "params（修改的数组，在上面设置age的值时可以直接引用）": {
            "数组key1": "数组的值value1",
            "数组key2": "数组的值value2"
        }
    }
}
````

# TODO

补充script相关知识





__修改成功:__

> 修改成功result值为"updated" 修改数据无改变result值为"noop",successful为影响条数

````
{
  "_index": "user",
  "_type": "list",
  "_id": "100",
  "_version": 8,
  "result": "updated",
  "_shards": {
    "total": 0,
    "successful": 1,
    "failed": 0
  }
}
````

### 删除文档

__delete__:``http://ip:端口/索引名(index)/类型名(type)/文档id(直接delete方式请求即删除)``

__成功返回:__

> 删除成功result值为"deleted" 删除数据为空result值为"not_found"通过ID删除successful都是1

````
{
  "_index": "user",
  "_type": "list",
  "_id": "100",
  "_version": 10,
  "result": "deleted",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 9,
  "_primary_term": 1
}
````

### 删除索引

__delete__:`` http://ip:端口/索引名(index)(直接delete方式请求即删除)``

__成功返回__

````
{
  "acknowledged": true
}
````

__不存在返回错误__

````
{
  "error": {
    "root_cause": [
      {
        "type": "index_not_found_exception",
        "reason": "no such index",
        "resource.type": "index_or_alias",
        "resource.id": "user",
        "index_uuid": "_na_",
        "index": "user"
      }
    ],
    "type": "index_not_found_exception",
    "reason": "no such index",
    "resource.type": "index_or_alias",
    "resource.id": "user",
    "index_uuid": "_na_",
    "index": "user"
  },
  "status": 404
}
````

### 查询数据

1. 概念

__结构化查询(query DSL)：__会计算每个文档与查询语句的相关性，会给出一个相关性评分 `_score`，并且 按照相关性对匹配到的文档进行排序。 这种评分方式非常适用于一个没有完全配置结果的全文本搜索。查询语句会询问每个文档的字段值与特定值的匹配程度如何？

__结构化过滤(Filter DSL):__在结构化过滤中，我们得到的结果 *总是* 非是即否，要么存于集合之中，要么存在集合之外。结构化过滤不关心文件的相关度或评分；它简单的对文档包括或排除处理。执行速度非常快，不会计算相关度（直接跳过了整个评分阶段）而且很容易被缓存。一条过滤语句会询问每个文档的字段值是否包含着特定值

2. 简单查询

   __GET__:``httｐ://ip:端口号/索引(index)/类型名(type)/文档id（直接get请求即可查询）``

3. 条件查询

   __POST__:``http://ip:端口号/索引(index)/_search【关键词】(指定查询)``

````json
{
    "from【关键词】(从第几条开始返回)": 1,
    "size【关键词】(返回多少条)": 1,
    "sort【关键词】（排序）": [
        {
            "属性值": {
                "order【关键词】(代表排序)": "desc/asc(排序方式)"
            }
        }
    ],
    "_source【关键字】(表示需要查的字段)": ["name","age"],
    "query【关键词】(指定条件查询)": {
        "match_all【关键词】(//方式1:查询所有的内容代表所有内容)": {},
        "match【关键词】（//方式2：关键词查询代表不是所有内容，有条件）": {
            "属性名": "属性值"
        }
    }
}
````

__查询语法:__

* query

> 说明：过滤语句集合

* filtered

> 说明：过滤器，已废弃

* match_all 

> 说明：查询所有

````
{
    "query": {
        "match_all": {}
    }
}
````

* bool

> 说明：复合过滤器，它可以接受多个其他过滤器作为参数，并将这些过滤器结合成各式各样的布尔（逻辑）组合，`bool` 过滤器本身仍然还只是一个过滤器。 这意味着我们可以将一个 `bool` 过滤器置于其他 `bool` 过滤器内部，

````
{
    "query": {
        "bool": {
            "must": [
                {
                    "term": {
                        "name": {
                            "value": "abc"
                        }
                    }
                }
            ],
            "must_not": [
                {
                    "term": {
                        "age": {
                            "value": "12"
                        }
                    }
                }
            ]
        }
    }
}
````

* filter

> 说明：过滤器，不进行评分或相关度的计算，所以所有的结果都会返回一个默认评分 `1`

````json
{
    "query": {
        "bool": {
            "filter": [
                {
                    "match": {
                        "username": {
                            "query": "中交9",
                            "operator": "or"
                        }
                    }
                },
                {
                    "match": {
                        "nickname": {
                            "query": "1112",
                            "operator": "or"
                        }
                    }
                }
            ]
        }
    }
}
````

* term

> 说明：精确查询，在倒排索引中查询，因为值被分词在倒排索引中，所以也可以说包含，不会将传递的数据分词，match会将传递的数据分词

````
{
    "query": {
        "bool": {
            "must": [
                {
                    "term": {
                        "name": {
                            "value": "abc"
                        }
                    }
                }
            ]
        }
    }
}
````

* terms

> 说明：在倒排索引中精确匹配多个数据，是``term``的复数版

````
{
    "query": {
        "bool": {
            "must": [
                {
                    "terms": {
                        "name": [
                            "aaa",
                            "bbb"
                        ]
                    }
                }
            ]
        }
    }
}
````

* constant_score

> 说明：查询以非评分模式来执行。将一个不变的常量评分应用于所有匹配的文档。它被经常用于你只需要执行一个 filter 而没有其它查询（例如，评分查询）的情况下。
>
> 给每条记录以一条固定的评分，即不计算相关度评分,所能constant_score只支持filter上下文
>
> https://www.elastic.co/guide/cn/elasticsearch/guide/cn/combining-queries-together.html

````
{
    "constant_score":   {
        "filter": {
            "term": { "category": "ebooks" } 
        }
    }
}
````

* must

> 说明：所有的语句都 *必须（must）* 匹配，与 `AND` 等价。

````json
{
    "query": {
        "bool": {
            "must": [
                {
                    "match": {
                        "id": "100"
                    }
                }
            ]
        }
    }
}
````

* must_not

> 说明：所有的语句都 *不能（must not）* 匹配，与 `NOT` 等价。

````json
{
    "query": {
        "bool": {
            "must_not": [
                {
                    "match": {
                        "id": "100"
                    }
                }
            ]
        }
    }
}
````


* should

> 说明：至少有一个语句要匹配，与 `OR` 等价。

````json
{
    "query": {
        "bool": {
            "should": [
                {
                    "match": {
                        "id": "100"
                    }
                }
            ]
        }
    }
}
````

* range

> 说明：范围查询
>
> `gt`: `>` 大于（greater than）
> `lt`: `<` 小于（less than）
> `gte`: `>=` 大于或等于（greater than or equal to）
> `lte`: `<=` 小于或等于（less than or equal to）

````json
"range" : {
    "price" : {
        "gte" : 20,
        "lte" : 40
    }
}
````

查询过去一小时内的

````json
"range" : {
    "timestamp" : {
        "gt" : "now-1h"
    }
}
````

日期计算还可以被应用到某个具体的时间，并非只能是一个像 now 这样的占位符。只要在某个日期后加上一个双管符号 (`||`) 并紧跟一个日期数学表达式就能做到:早于 2014 年 1 月 1 日加 1 月（2014 年 2 月 1 日 零时）

````json
"range" : {
    "timestamp" : {
        "gt" : "2014-01-01 00:00:00",
        "lt" : "2014-01-01 00:00:00||+1M" 
    }
}
````

范围查询同样可以处理字符串字段， 字符串范围可采用 *字典顺序（lexicographically）* 或字母顺序（alphabetically）。例如，下面这些字符串是采用字典序（lexicographically）排序的：

5, 50, 6, B, C, a, ab, abb, abc, b

````json
"range" : {
    "title" : {
        "gte" : "a",
        "lt" :  "b"
    }
}
````

* exists

> 说明：查询会返回那些在指定字段有任何值的文档

````json
POST station/_search
{
    "query": {
        "bool": {
            "must": [
                {
                    "exists": {
                        "field": "fieldName"
                    }
                }
            ]
        }
    }
}
````

> 返回指定字段不存在任何值的文档

````json
POST station/_search
{
    "query": {
        "bool": {
            "must_not": [
                {
                    "exists": {
                        "field": "fieldName"
                    }
                }
            ]
        }
    }
}
````

* match

> 说明：对搜索的字符串进行分词，从目标字段中的倒序索引中查找是否有其中某个分词．
>
> 参数有：
>
> query:""	查询的数据
>
> operator:"or"	默认"or"可不写，表示query中的数据分词后匹配中一个词条则该文档符合，"and"表示query中的数据分词后需要全部匹配上的文档才符合
>
> minimum_should_match:2	表示query分词后与文档中至少匹配的词条数量，当operator为and时设置minimum_should_match搜索结果为空
>
> 在6.x已经不支持在math里面使用type，之前加上"type":"pharse"功能和match_pharse相同

````json
{
    "query": {
        "bool": {
            "must": [
                {
                    "match": {
                        "sku_name_string": {
                            "query": "你好 再见",
                            "operator": "or",
														"minimum_should_match" : 2
                        }
                    }
                }
            ]
        }
    }
}
````

* match_pharse

> 说明：先将搜索的内容拆词，拆成词条后，每个词条与倒排索引中词条匹配，同时匹配上所有搜索内容的词条，并且顺序一样，则该文档符合搜索
>
> 参数有：
>
> query:""	查询的数据
>
> analyzer:"whitespace"	将所有的内容以何中分词方式分成词条，然后与倒排索引中的词条匹配
>
> slop:2	slop参数告诉match_phrase查询词条能够相隔多远时仍然将文档视为匹配。相隔多远的意思是，你需要移动一个词条多少次来让查询和文档匹配？

````json
{
    "query": {
        "bool": {
            "must": [
                {
                    "match_phrase": {
                        "sku_name_string": {
                            "query": "京VI",
                            "analyzer": "whitespace",
                            "slop" : 2
                        }
                    }
                }
            ]
        }
    }
}
````

* multi_match

> 说明：用于匹配多个字段匹配同一个内容，搜索内容分词后与倒排索引中多个字段匹配
>
> 参数有：
>
> query:""	查询的数据
>
> fields:["username","nickname"]	匹配的字段
>
> type:"best_fields"	过滤筛选的类型，
>
> ​	"best_fields"只要任意匹配一个字段即可，使用最匹配的那个字段相关度评分；
>
> ​	"more_fields"只要匹配做任意一个字段，但会将匹配度的得分进行组合；
>
> ​	"corss_fields"使用相同的分词器，只要有一个字段匹配即可；
>
> ​	"phrase"先将搜索内容以fields中字段的方式分词，然后使用match_phrase方式与fields中每个字段匹配。对每个字段运行match_phrase查询，并合并每个字段的权重
>
> ​	"phrase_prefix"最匹配的字段要完全匹配搜索的内容(包含搜索的内容)，与phrase类似，观察到在将搜索内容分词的后面会有``*``号，原字段分词方式为：username 空格分词 nickname是一字一词通过validate验证得到explanation可分析搜索过程， `` "explanation": """+(+(username:"小明 小红*" | nickname:"小 明 红*")) #DocValuesFieldExistsQuery [field=_primary_term]"""`` 猜测可能是通配符意思。对每个字段运行match_phrase_prefix查询，并合并每个字段的权重
>
> operator:"or"	默认"or"可不写，表示query中的数据分词后匹配中一个词条则该文档符合，"and"表示query中的数据分词后需要全部匹配上的文档才符合[比较复杂未实验]

````json
{
    "query": {
        "bool": {
            "must": [
                {
                    "multi_match": {
                        "query": "小明 小红",
                        "fields": [
                            "username",
                            "nickname"
                        ],
                        "type": "phrase"
                    }
                }
            ]
        }
    }
}
````

* prefix

> 说明：搜索指定字段在倒排索引中的词条以指定内容开头的文档，指定的字段不分词

````json
{
    "query": {
        "bool": {
            "must": [
                {
                    "prefix": {
                        "username": {
                            "value": "阿东"
                        }
                    }
                }
            ]
        }
    }
}
````

* regexp/wildcard

> 说明：正则匹配。与 `prefix` 前缀查询的特性类似， `wildcard` 通配符查询也是一种底层基于词的查询， 与前缀查询不同的是它允许指定匹配的正则式。它使用标准的 shell 通配符查询： `?` 匹配任意字符， `*` 匹配 0 或多个字符

````json
{
    "query": {
        "wildcard": {
            "postcode": "W?F*HW" 
        }
    }
}
````

`wildcard` 和 `regexp` 查询的工作方式与 `prefix` 查询完全一样，它们也需要扫描倒排索引中的词列表才能找到所有匹配的词，然后依次获取每个词相关的文档 ID ，与 `prefix` 查询的唯一不同是：它们能支持更为复杂的匹配模式。

这也意味着需要同样注意前缀查询存在性能问题，对有很多唯一词的字段执行这些查询可能会消耗非常多的资源，所以要避免使用左通配这样的模式匹配（如： `*foo` 或 `.*foo` 这样的正则式）。

数据在索引时的预处理有助于提高前缀匹配的效率，而通配符和正则表达式查询只能在查询时完成，尽管这些查询有其应用场景，但使用仍需谨慎。

* dis_max

> 说明：在多字段全文检索时，固定相关度评分，不计算相关度评分，而是尽可能多的field匹配了少数的关键词(取分数最高的那个字段的分数)；
>
> `dis_max` 查询只会简单地使用单个最佳匹配语句的评分 `_score` 作为整体评分
>
> 参数如下：
>
> ​	queries:[]	多匹配条件
>
> ​	boost:
>
> ​	tie_breaker:0.3	可以通过指定 `tie_breaker` 这个参数将其他匹配语句的评分也考虑其中，指定后算法如下：
>
> 		1. 获取最佳匹配语句的评分``_source``
>   		2. 将其他匹配语句的评分结果与``tie_breaker``相乘
>   		3. 对以上评分求和，并规范化
>
> 有了 `tie_breaker` ，会考虑所有匹配语句，但最佳匹配语句依然占最终结果里的很大一部分。
>
> https://www.elastic.co/guide/cn/elasticsearch/guide/current/_tuning_best_fields_queries.html

````
{
    "query": {
        "dis_max": {
            "queries": [
                {
                    "term": {
                        "status": 1
                    }
                },
                {
                    "match": {
                        "address": "zhejiang"
                    }
                }
            ]
        }
    }
}
````

* boost

> 说明：让一个查询语句比其他语句更重要
>
> *查询时的权重提升* 是可以用来影响相关度的主要工具，任意类型的查询都能接受 `boost` 参数。 将 `boost`设置为 `2` ，并不代表最终的评分 `_score` 是原值的两倍；实际的权重值会经过归一化和一些其他内部优化过程。尽管如此，它确实想要表明一个提升值为 `2` 的句子的重要性是提升值为 `1` 语句的两倍。
>
> 在实际应用中，无法通过简单的公式得出某个特定查询语句的 “正确” 权重提升值，只能通过不断尝试获得。需要记住的是 `boost` 只是影响相关度评分的其中一个因子；它还需要与其他因子相互竞争。在前例中， `title` 字段相对 `content` 字段可能已经有一个 “缺省的” 权重提升值，这因为在 [字段长度归一值](https://www.elastic.co/guide/cn/elasticsearch/guide/current/scoring-theory.html#field-norm) 中，标题往往比相关内容要短，所以不要想当然的去盲目提升一些字段的权重。选择权重，检查结果，如此反复。
>
> https://www.elastic.co/guide/cn/elasticsearch/guide/current/query-time-boosting.html

````
GET /docs_2014_*/_search 
{
  "indices_boost": { 
    "docs_2014_10": 3,
    "docs_2014_09": 2
  },
  "query": {
    "match": {
      "text": "quick brown fox"
    }
  }
}
````

* _source

> 说明：指定返回字段

````
{
  "_source": ["oss_name","osp_name"],
 }
````

__验证查询的合法性__

````json
GET station/_validate/query?explain
{
  "query": {
    "match": {
      "sku_name_string": "0# 柴油 国Ⅴ 0# 柴油 国Ⅵ"
    }
  }
}
````

正确返回：

````
{
  "valid": true,
  "_shards": {
    "total": 1,
    "successful": 1,
    "failed": 0
  },
  "explanations": [
    {
      "index": "station",
      "valid": true,
      "explanation": "sku_name_string:0# sku_name_string:柴油 sku_name_string:国Ⅴ sku_name_string:0# sku_name_string:柴油 sku_name_string:国Ⅵ"
    }
  ]
}
````

错误返回：

````
{
  "valid": false,
  "error": "org.elasticsearch.common.ParsingException: no [query] registered for [sku_name_string]"
}
````

__高亮我们的搜索__

````
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
````

__多索引关联查询__

> 一下查询意思为：从info索引中取出id为1的数据的user_id，做为user索引中等于user_id的条件条件，取出如何条件数据的user_id、status
>
> terms中可以这么使用
>
> match中不可以这么使用 ``"[match] query does not support [index]"``

````
POST user/_search
{
    "_source": [
        "user_id",
        "status"
    ],
    "query": {
        "terms": {
            "user_id": {
                "index": "info",
                "type": "_doc",
                "id": 1,
                "path": "user_id"
            }
        }
    }
}
````

__通过ids查询__

````json
POST myIndex/_search
{
  "query": {
    "ids": {
      "values": [300,301]
    }
  }
}
````

__检测分词__

> 一下会根据myIndex中fieldName的分词规则来分text的内容

````
POST myIndex/_analyze
{
    "field": "fieldName",
    "text": "你好 很高兴"
}
````

> 返回内容格式如下

````
{
  "tokens" : [
    {
      "token" : "你好",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "很高心",
      "start_offset" : 9,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 1
    }
  ]
}
````



>在查询过程中，除了判断文档是否满足查询条件外，es还会计算一个_score来标示匹配的程度，旨在判断目标文档和查询条件匹配的 有多好;

 post:``http://ip:端口号/索引(index)/_search【关键词】(指定查询)``

  ````
  {
      "query【关键词】(指定条件查询)" : {
      
      	//方式1 match 先将搜索的内容拆词，拆成不重复的词条后，每个词条与倒排索引中词条匹配，operator默认为"or" 表示有一个相同，则该文档符合搜索，如果operator为"and"表示需要数据包含所有搜索的分词
          "match【关键词】（代表不是所有内容，有条件）" : {
              "属性名" : {
              	"query" : "属性值",
              	"operator" : ""
              }
          }
          
          //方式2 match_phrase 先将搜索的内容拆词，拆成词条后，每个词条与倒排索引中词条匹配，同时匹配上所有搜索内容的词条，并且顺序一样，则该文档符合搜索
          //例如：
          //	文档：我的名字叫小明
          //	搜索：明 则没有结果
          //	原因：我的名字叫小明 倒排索引中(我、的、名字叫、名字、叫、小明) 没有"明"所以没有匹配上
          "match_phrase【关键词】 （代表不是所有内容，有条件）" : {
              "属性名" : "属性值"
          }
          
          //方式3 multi_match 先将搜索的内容拆词，拆成词条后，每个词条与倒排索引中只是field属性的词条匹配，field属性的词条中至少一个与搜索内容的词条相同，则该文档符合搜索
          "multi_match【关键词】 （代表多个属性符合一个条件查询）" : {
              "query【关键词】(查询内容)" : "内容值",
              "fields【关键词】（需要服务上面query的条件的属性）" : ["属性1","属性2"]，,
              "type": "best_fields", //对匹配到两个以上的分值*2  most_fields:匹配程度越高分值越高 cross_fields:词条的分词是匹配到不同字段中的，好像没什么用
              "tie_breaker": 2
          }
          
          //方式4 query_string 代表语法查询
          "query_string【关键词】（代表语法查询）" : {
              "query【关键字】（查询条件）" : "aaa",	//表示所有文档的任意一个属性包含aaa的数据
              //"query【关键字】（查询条件）" : "aaa AND bbb ",	//表示所有文档的任意一个属性包含aaa和bbb的数据
              //"query【关键字】（查询条件）" : "(aaa AND bbb) OR ccc ",	//表示所有文档的任意一个属性包含aaa和bbb 或者 包含ccc 的数据
              
              //"query【关键字】（查询条件）" : "(aaa AND bbb) OR ccc ",
              //"fields【关键词】（指定匹配的属性）" : 	//表示所有文档的指定属性包含aaa和bbb 或者 包含ccc 的数据
          }
          
          //方式5 term 字段查询，对字段进行精确匹配，不拆分搜索内容，对text类型字段，如果该字段分词了，搜索内容与倒排索引中有一个相同，则该文档符合搜索条件，text类型字段分词方案由创建索引时analyze确；
          //如果搜索的内容是一个词，match、match_phrase效果一样，因为match、match_phrase对搜索内容进行非，但只能分成一个词，一个词然后匹配倒排索引中相同的文档，效果和term一样；
          "term【关键词】（指定字段查询）" : {
              "属性名" : "属性值"	//查询属性名为属性值的数据，如果文档中有匹配的词，但是没有查询出来，可能是这个字段使用的analyze， 搜索的属性值不在分词的词条内；或者创建时声明not_analyzed
          }
          
          "terms【关键词】(指定包含查询)": {
              "属性名" : ["属性值1","属性值2","属性值3"]
          }
          
          //range 范围查询   值处可用关键词"now" 表示当前日期
          "range【关键词】（范围查询）" : {
              "属性值（number）" : {
                  "对比方式开始(gte)" ： "值（1000）",
                  "对比方式结束(lte)" ： "值（2000）"
              }
          }
      }
  }
  ````
__负责类型嵌套__

````
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "eggs" 
          }
        },
        {
          "nested": {
            "path": "一级属性名", 
            "query": {
              "bool": {
                "must": [ 
                  {
                    "match": {
                    //可修改为不同筛选条件
                      "一级属性名.二级属性名": "属性值"      
                    }
                  },
                  {
                    "match": {
                      "一级属性名.二级属性名": "属性值"
                    }
                  }
                ]
              }
            }
          }
        }
      ]
}}}
````

__范围搜索__

>  geo_distance:查找距离某个中心点距离在一定范围内的位置
>
>  500km以内

````
{
    "must": [
        {
            "geo_distance": {
                "distance": "500km",
                "location": {
                    "lat": "24.46667",
                    "lon": "118.1"
                }
            }
        }
    ]
}
````

> geo_bounding_box:查找某个长方形区域内的位置

````
{
    "must": [
        {
            "geo_bounding_box": {
                "location": {
                    "top_left": {
                        "lat": 40.8,
                        "lon": -74
                    },
                    "bottom_right": {
                        "lat": 40.715,
                        "lon": -73
                    }
                }
            }
        }
    ]
}
````

> geo_distance_range:查找距离某个中心的距离在min和max之间的位置

````
{
    "must": {
        "geo_distance_range": {
            "gte": "1km",
            "lt": "2km",
            "location": {
                "lat": 40.715,
                "lon": -73.988
            }
        }
    }
}
````

> geo_polygon:查找位于多边形内的地点。

### 数据排序

#### 普通排序

````
{
  "sort": [
    {
      "FIELD": {
        "order": "desc"
      }
    }
  ]
}
````

#### 距离排序

````
{
  "sort": [
    {
      "_geo_distance": {
        "order": "desc",
        "unit": "km",
        "distance_type": "plane",
        "location": {
          "lat": 40,
          "lon": -70
        }
      }
    }
  ]
}
````

#### 排序条件







### 聚合查询

__POST__:``http://ip:端口号/索引(index)/_search【关键词】(指定查询) ``

````
{
	//方式1
    "aggs【关键词】(指定聚合查询)" : {
        "聚合查询名称1 例如：group_by_age 根据年龄分组，返回结果在返回json 数组中，key为名称" : {
            "trems【关键词】（本组聚合内容）" : {
                "field【关键词】(指定属性)" : "属性名"
            }
        },
        "聚合查询名称2例如：group_by_sex 根据性别分组，返回结果和1 并列在数组中，key为名称" : {
            "trems【关键词】（本组聚合内容）" : {
                "field【关键词】(指定属性)" : "属性名"
            }
        },
    }
    
    //方式2 ： 统计计算
    //返回 count 数据条数、min 最小一条多少、max 最大一条多少、 avg 平均多少、 sum 共多少 
    "aggs" : {
        "grades_word_count" : {
            "stats【关键词】（代表计算或者count/min/max/avg/sum指定计算的结果值）" : {
                 "field【关键词】(指定属性)" : "属性名"
            }
        }
    }
}
````

### 批量操作

> 除删除外每条操作前面必须跟{"index":{"_index":"索引名","_type":"类型","_id":"x"}}
>
> 每一段json不能换行，第二段之间不能有空行 每行换行'\n'
>
> 前6行为添加 三条数据，7-8为更新，9为删除

__POST__:``_buld``
````
{"index":{"_index":"zhouls","_type":"emp","_id":"10"}}
{ "name":"jack", "age" :18}
{"index":{"_index":"zhouls","_type":"emp","_id":"11"}}
{ "name":"jack", "age" :18}
{"index":{"_index":"zhouls","_type":"emp","_id":"12"}}
{"name":"tom", "age":27}
{"update":{"_index":"zhouls","_type":"emp", "_id":"2"}}
{"doc":{"age" :22}}
{"delete":{"_index":"zhouls","_type":"emp","_id":"1"}}
````



## 字段类型

> elasticsearch6.0

### 基础类型：
* 字符类型： `` text、keyword``    
* 数字类型： `` long、integer、short、byte、double、float、half_float、sacled_float``     
* 日期类型： ``date``    ( "yyyy-mm-dd HH:mm:ss || yyyy-MM-dd||epoch_millis")
* 布尔类型： `` boolean``    
* 字节型：`` binary``     
* 范围型：`` integer_range、float_range、long_range、double_rang、date_range``    

### 复杂类型:
* 数组类型（array）：数组类型不需要明确声明内容类型  
* 类类型(object)：只针对于一个json类型的类。
* 嵌套类型(nested)：嵌套json数组

### 地标类型:
* 地标坐标(geo-point)：经纬度坐标
* 地标形状类型(geo_shape)：复杂的图形

### 特殊类型：
* ip类型(ip)：IPv4、IPv6
* 自动完成类型(completion)：会自动完成补全的类型.
* 令牌统计类型（token_count）：统计字符串中的数量
* 哈希计算类型（murmur3）：在创建索引的时候就会计算出哈希值并存储
* 渗透类型(percolator)：接受从query-dsl来的请求
* 联合类型（join）：定义同一个index中，document的子父的关系

### Multi-Fields
> 有时候我们搜索的时候需要把一个字段的类型定义为full-text，当排序的时候又需要把它当做keyword类型，这个时候我们就需要使用Multi-Fields类型了，[使用参考](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html)，可以使用[fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html)来对大部分类型做Multi-Fields处理。

__格式如下：__

````json
{
    "properties": {
        "city": {
            "type": "text",
            "fields": {
                "raw": {
                    "type": "keyword"
                }
            }
        }
    }
}
````



## 分词器

- standard 分词器：英文的处理能力同于StopAnalyzer.支持中文采用的方法为单字切分。他会将词汇单元转换成小写形式，并去除停用词和标点符号

- simple 分词器：功能强于WhitespaceAnalyzer, 首先会通过非字母字符来分割文本信息，然后将词汇单元统一为小写形式。该分析器会去掉数字类型的字符

- Whitespace 分词器：仅仅是去除空格，对字符没有lowcase化,不支持中文； 并且不对生成的词汇单元进行其他的规范化处理。

- Stop 分词器：StopAnalyzer的功能超越了SimpleAnalyzer，在SimpleAnalyzer的基础上增加了去除英文中的常用单词（如the，a等），也可以更加自己的需要设置常用单词；不支持中文

- keyword 分词器：KeywordAnalyzer把整个输入作为一个单独词汇单元，方便特殊类型的文本进行索引和检索。针对邮政编码，地址等文本信息使用关键词分词器进行索引项建立非常方便。

- pattern 分词器：一个pattern类型的analyzer可以通过正则表达式将文本分成"terms"(经过token Filter 后得到的东西 )。接受如下设置:

  一个 pattern analyzer 可以做如下的属性设置:

  lowercaseterms是否是小写. 默认为 true 小写.pattern正则表达式的pattern, 默认是 \W+.flags正则表达式的flagsstopwords一个用于初始化stop filter的需要stop 单词的列表.默认单词是空的列表

- language 分词器：一个用于解析特殊语言文本的analyzer集合。不支持中文。

- snowball 分词器：一个snowball类型的analyzer是由standard tokenizer和standard filter、lowercase filter、stop filter、snowball filter这四个filter构成的。

  snowball analyzer 在Lucene中通常是不推荐使用的。

- Custom 分词器：是自定义的analyzer。允许多个零到多个tokenizer，零到多个 Char Filters. custom analyzer 的名字不能以 "_"开头.

  The following are settings that can be set for a custom analyzer type:

  SettingDescriptiontokenizer通用的或者注册的tokenizer.filter通用的或者注册的token filterschar_filter通用的或者注册的 character filtersposition_increment_gap距离查询时，最大允许查询的距离，默认是100

- ik-analyzer：中文分词器，需要手动安装。

### 中文分词器安装

选择适合的版本 下载

````
https://github.com/medcl/elasticsearch-analysis-ik/releases
````

在你的es安装目录中的plugin中新建ik目录

解压下载的elasticsearch-analysis-ik-6.2.4内容copy到ik中

#### 自定义词典

	cd ik/config
	
	vim yourdic.dic 一行代表一个词
	
	vim IKAnalyzer.cfg.xml

````
 <!--用户可以在这里配置自己的扩展字典 -->
 <entry key="ext_dict">yourdic.dic</entry>
 <!--用户可以在这里配置自己的扩展停止词字典-->
````

重启elasticsearch

#### 测试中文分词器

创建索引、使用中文分词

````
PUT user
{
 "mappings": {
   "xiaoming" : {
     "properties": {
       "name" : {
         "type": "text",
         "analyzer": "ik_max_word"
       }
     }
   }
 }
}
````

插入数据

```
POST user/xiaoming
{
  "name" : "我的名字叫小明"
}
```

查看分词效果

````
GET user/_analyze
{
  "field": "name",
  "text": "我的名字叫小明"
}
````



## 结合PHP

* 安装elasticSearch PHP扩展(注意版本)

  `` "elasticsearch/elasticsearch": "~6.0" ``

## ERROR

* No handler for type [string] declared on field [first_name]"}

  * 表示elasticsearch6.0里面不支持string类型，只有text、keyword类型

*  Result window is too large, from + size must be less than or equal to: [10000] 

   * ES提示我结果窗口太大了，目前最大值为10000，而我却要求给我10000000。并且在后面也提到了要求我修改`index.max_result_window`参数来增大结果窗口大小。

   ````
   curl -XPUT http://127.0.0.1:9200/indexName/_settings -d '{ "index" : { "max_result_window" : 100000000}}'
   ````

* FORBIDDEN/12/index read-only / allow delete (api)];

   > 磁盘满了后 es会将数据设置只读锁起来
   >
   > 解决方案：
   >
   > ​	1 解锁，删除一部分数据，将服务器中磁盘空间清理
   >
   > ​	2 加磁盘

````
//设置所有非只读模式
PUT _settings
{
  "index": {
    "blocks": {
      "read_only_allow_delete": "false"
    }
  }
}
//获取索引信息
GET queue/_settings?pretty

//设置指定索引为非只读模式
PUT queue/_settings
{
  "index.blocks.read_only_allow_delete": false
}
// 清空指定索引
POST queue/list/_delete_by_query?conflicts=proceed
{
  "query" : {
    "match_all" :{}
  }
}

//查询es中磁盘使用情况
GET _cat/allocation?v
````

* **missing authentication token for REST request**

  > 没有权限

* Whitespace 空格分词 实测可用
* search_analyzer 对请求的数据分词方式 analyzer 对es中数据分词
* 自定义分词需要先向es中设置分词方式 例如逗号分词,再和普通设置分词方式相同设置分词方式为设置的名字，一下案例中分词名为都douhao

````
curl -XPOST 'http://172.18.0.4:9200/demo/?pretty' -d '
{
　　"settings":
　　{
　　　　"analysis":
　　　　　　{
　　　　　　　　"analyzer":
　　　　　　　　　　{
　　　　　　　　　　　　"douhao":
　　　　　　　　　　　　　　{
　　　　　　　　　　　　　　　　"type":"pattern",
　　　　　　　　　　　　　　　　"pattern":","
　　　　　　　　　　　　　　}
　　　　　　　　　　}
　　　　　　}
　　}
}'
````

* 分词只对text类型数据有效，keyword为整个值为一个词，其实就相当于没有分词

* 复杂类型中array 表示一个属性的值为一个数组，如下，__数组中的数据类型必须相同__

````
"a" : ["1","2","3"]
````

* Elastic search 6以前复杂类型会有 ``object``如下1，elastic search6以后没有``object`` 默认类型嵌套处理如下2

````
{
  "gb": {
    "tweet": 
      "properties": {
        "tweet":            { "type": "string" },
        "user": {
          "type":             "object",
          "properties": {
            "id":           { "type": "string" },
            "gender":       { "type": "string" },
            "age":          { "type": "long"   },
            "name":   { 
              "type":         "object",
              "properties": {
                "full":     { "type": "string" },
                "first":    { "type": "string" },
                "last":     { "type": "string" }
              }
            }
          }
        }
      }
    }
  }
}
````

````
{
  "test": {
    "mappings": {
      "test": {
        "properties": {
          "tweet": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            }
          },
          "user": {
            "properties": {
              "age": {
                "type": "long"
              },
              "gender": {
                "type": "text",
                "fields": {
                  "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                  }
                }
              },
              "id": {
                "type": "text",
                "fields": {
                  "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                  }
                }
              },
              "name": {
                "properties": {
                  "first": {
                    "type": "text",
                    "fields": {
                      "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                      }
                    }
                  },
                  "full": {
                    "type": "text",
                    "fields": {
                      "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                      }
                    }
                  },
                  "last": {
                    "type": "text",
                    "fields": {
                      "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
````

* **嵌套对象** nested  与``object`最大的区别是 nested会将嵌套中的每条数据当成一个整体，``object``会将嵌套数据中相同属性数据索引在一起，这样搜索就产生混乱 举例如下

  一条数据有一个嵌套字段 其中包含两条数据 ``[{ "name" : "a", "age":2},{"name":"b","age","2"}]``

  搜索条件是 name = a, age = 2

  如果是object类型就会搜出来 它会这样索引 name:["a","b"], age:["1","2"] 这样 a在name中匹配上，2在age中匹配上，所以就能搜到，

  nested 则不会，它会将``{ "name" : "a", "age":2}``, ``{"name":"b","age","2"}]``分别独立