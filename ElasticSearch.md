[TOC]



# ElasticSearch

> es 版本1.0x 、2.0x、5.0x   版本跳转是为了统一elk所有版本

## Install

> 不可用root用户操作，必须使用普通用户，且下载解压的所有文件所属用户为普通用户；
>
> elasticsearch 创建搜索时默认创建5个分片，一个备份

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

  * cluster.name: 集群名【如果使用集群，多个节点这个属性需要一直】

  * node.name : 节点名【如果使用集群，多个节点这个属性需要全部不同】

  * node.master:是否为master (集群使用)【如果使用集群，Master节点此处为true，Slave节点此处为false】

  * network.host:绑定iP

  * discovery.zen.ping.unicast.hosts:["集群MasterIP"]　找到master主机iP，【集群salve节点必须设置，master节点不需要设置】

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

## Elasticsearch-head

### Install

> elasticsearch-head是个用来与Elasticsearch互动的图形化界面插件，有了他你可以很方便的管理你的Elasticsearch，查看你的Elasticsearch状态或者测试你的查询语句。这个是他官方的`GitHub页面`。

* 安装(使用root用户) 下载去githut搜索elasticsearch-head 选择mobz开头的

  ````
  git clone git://github.com/mobz/elasticsearch-head.git
  cd elasticsearch-head
  npm install
  //速度较慢，就是用国内镜像 npm install -g cnpm --registry=https://registry.npm.taobao.org
  grunt server
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

### ERROR

  ````
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

## 安装npm

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



## ES结构

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



## ES使用

* 关闭Elasticsearch

  * Ctrl+c
  * kill -9 进程好
  * curl 请求关闭 : curl -XPOST http://localhost:9200/_cluster/nodes/_shutdown
  * Curl 关闭某一个nod : curl -XPOST http://localhost:9200/_cluster/nodes/节点标识符/_shutdown 

* 创建索引： url （post）： http://ip:端口/索引(index)/类型(type)/_mappings(【关键词】：映射 表示字段fields)

  * ````
    {
         "类型" : {
             //结构
             "properties(关键词，定义每一个字段)" : {
                 "字段1" :{
                     "type(关键词，字段类型)" : "字段具体类型"
                 }
             }
         }
    }
    ````

 * 创建索引 url （put）：http://ip:端口/索引(index)

   * ````
     {
     	//settings指定索引配置
         "settings【关键词】" : {
             "number_of_shards【关键词】" : 指定索引的分片数，
             "number_of_replicas【关键词】" : 指定索引备份数，
         }
         //mappings索引的映射定义
         "mappings【关键词】" : {
             "类型名1(type)" : {
                 "properties【关键词】属性定义集合" : {
                     "属性名1" : {
                         "type【关键词】类型值" : "",
                         "analyzer【关键词】（分词设置）" : ""
                     },
                      "属性名2" : {
                         "type【关键词】类型值" : ""
                     }
                 }
             }，
             "类型名2(type)" : {
             	//可以为空，表示无结构类型
             }
         }
     }
     ````

     更多说明：

     ````
     "name":{
     	"type":"string",
     	//公共属性
     	"store":"yes",
     	"index":"not_analyzed", //analyzed:编入索引供搜索、no:不编入索引、not_analyzed(string专有):不经分析编入索引
     	"boost":"1",    //文档中该字段的重要性，值越大表示越重要，默认1
     	"null_value":"jim",  //当索引文档的此字段为空时填充的默认值，默认忽略该字段
     	"include_in_all":"xxx"      //此属性是否包含在_all字段中,默认为包含
     	//字符串特有属性
     	"analyzer":"xxx",     //定义用于索引和搜索的分析器名称，默认为全局定义的分析器名称。可以开箱即用的分析器:standard,simple,whitespace,stop,keyword,pattern,language,snowball
     	"index_analyzer":"xxx",           //定义用于建立索引的分析器名称
     	"search_analyzer":"xxx",        //定义用于搜索时分析该字段的分析器名称
     	"ignore_above":"xxx"      //定义字段中字符的最大值，字段的长度高于指定值时，分析器会将其忽略
     	}
     ````



  * 插入数据: url (post) : http://ip:端口号/索引名(index)/类型名(type)/文档id(不填es默认会创建)

    * ````
      {
          "属性名1" ： "属性值",
          "属性名2" ： "属性值"
      }
      ````

* 修改数据 :url (post) : htpp://ip:端口号/索引名(index)/类型名(type)/文档id/_update【关键词】(指定操作)

  > 在内部，Elasticsearch必须首先获取文档，从_source属性获取数据，删除旧的文件，更改 _source 属性，然后把它作为新的文档来索引，因为信息一但在Lucene中倒排索引中存储就不能再被修改，当并发是，尝试写入一个已经更改的文档将会失败，提示version error版本错误，这是elasticsearch中文档的版本控制功能(乐观锁)

  * ````
    {
    	//doc表示要修改的文档集合
        "doc【关键词】" : {
            "属性名1" : "新的属性值"
        }
    }
    ````

* 修改数据 :url (post) : htpp://ip:端口号/索引名(index)/类型名(type)/文档id/_update【关键词】(指定操作)

  * ````
    {
    	
        "script【关键词】(脚本的方式修改)" : {
            "lang【关键词】(指定脚本语言)" : "painless【关键词】(es内置的脚本语言，es支持很多中脚本语言js\python等)",
            
            //方式1：es内置语法 ctx代表es上下文，_source代表es当前文档，当前文档url中定义id为1的, .age += 10 代表将age属性的值加10
            "inline【关键词】(指定脚本内容)" : "ctx._source.age += 10"
            
            //方式2
            "inline【关键词】(指定脚本内容)" : "ctx._source.age = params.数组key"
            "params（修改的数组，在上面设置age的值时可以直接引用）" : {
                "数组key1" : "数组的值value1",
                "数组key2" : "数组的值value2"
            }
        }
    }
    ````

* 删除文档：url (delete) : http://ip:端口/索引名(index)/类型名(type)/文档id      (直接delete方式请求即删除)

* 删除索引：url (delete) : http://ip:端口/索引名(index)      (直接delete方式请求即删除)

* 查询

  * 简单查询 url (get)：httｐ://ip:端口号/索引(index)/类型名(type)/文档id		（直接get请求即可查询）

  * 条件查询 url (post) : http://ip:端口号/索引(index)/_search【关键词】(指定查询)

    ````
    {
        "query【关键词】(指定条件查询)" : {
        	"from【关键词】(从第几条开始返回)" : 1,
        	"size【关键词】(返回多少条)" ： 1,
        	"sort【关键词】（排序）" : [
                {"属性值" : { "order【关键词】(代表排序)" : "desc/asc(排序方式)"}}
        	],
        	"_source【关键字】(表示需要查的字段)" : ["name","age"],
        	
        	//方式1:查询所有的内容
            "match_all【关键词】(代表所有内容)" : {}
            
            //方式2：关键词查询，
            "match【关键词】（代表不是所有内容，有条件）" : {
                "属性名" : "属性值"
            }
        },
    }
    ````

    ````
    //响应说明
    ｛
    	"took" : ""， //相应时间,
    	"time_out" : "",	//是否超时"
    	"_shards" : "",		//涉及到的分片，所有分片，
    	"hits" : { //相应的所有数据
            "total" : ""	//本次搜索共多少数据
            "max_score" : "" 	//每一条docment对searching的相关度，愈大越前
            "hits" : {	//具体每条数据 默认返回10条数据
                ""
            }
    	}
    ｝
    ````

  * 聚合查询 url (post) : http://ip:端口号/索引(index)/_search【关键词】(指定查询) 其实就是分组，每组条数

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

* 高级查询

  * 子条件查询（特定字段查询所指特定值）

    __Query Context_  : 在查询过程中，除了判断文档是否满足查询条件外，es还会计算一个_score来标示匹配的程度，旨在判断目标文档和查询条件匹配的 有多好;

    url (post) : http://ip:端口号/索引(index)/_search【关键词】(指定查询)

    ````
    {
        "query【关键词】(指定条件查询)" : {
        
        	//方式1 match 先将搜索的内容拆词，拆成不重复的词条后，每个词条与倒排索引中词条匹配，有一个相同，则该文档符合搜索
            "match【关键词】（代表不是所有内容，有条件）" : {
                "属性名" : "属性值"
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
    补充：

    ````
    POST /blogs/blog/_search
    {
      "query": {
       "multi_match": {
         "query": "elasticsearch match query",
         "fields": ["title","descrption"],
         "tie_breaker": 20
       }
      }
    }
    ````

    通过设置tie_breaker参数来控制匹配的权重缓冲值,意思是每个字段都会在得到匹配之后都会对该值进行计算.
    ​	参数理解
    ​    multi_match查询收到许多参数控制,下面我们来看下这些参数对查询结果有哪些影响
    ​	type
    ​		* best_fields
    ​			(默认) 查找与任何字段匹配的文档，使用最佳字段中的权重。 详情参见：best_fields
    ​		* most_fields
    ​			查找与任何字段匹配的文档，并组合每个字段的权重。详情参见：most_fields.
    ​		* cross_fields
    ​			使用相同的分析仪处理字段，就像它们是一个大字段。 在任何字段中查找每个字词，详情参见：cross_fields.
    ​		* phrase
    ​			对每个字段运行match_phrase查询，并合并每个字段的权重，详情参见：phrase and phrase_prefix.
    ​		* phrase_prefix
    ​			对每个字段运行match_phrase_prefix查询，并合并每个字段的权重，详情参见：phrase and phrase_prefix

* analyze

    ````
    GET search_oss/_analyze
    {
      "field" : "oss_name",
      "text":"呼和浩特网点1"
    }
    这个会分成 呼、和、浩、特、网、点、1
    ````

* Filter 

    > Filter Context 在查询过程中，只判断该文档是否满足条件，只有yes或no

    ````
    {
        "query" : {
            "bool" : {
                "filter" : {
                    "term" : {
                        "属性名" : "属性值"
                    }
                }
            }
        }
    }
    ````

* wildcard 通配符 查询结果会慢

    ````
      "query": {
          "wildcard" : {
            "name" : "*小红*"
          }
      }
    ````

* 复合条件查询（以一定的逻辑组合子条件查询） 

    > 分数查询：通过query context查询会返回_score分数，该分数表示查询符合程度，分数查询就是给该分数一个条件例如：

    ````
     {
         "query" : {
             "constant_score【关键词】（表示分数查询）" : {
                 "filter" : {
                     "match" : {
                         "属性值" : "属性名"
                     }
                 },
                 "boost【关键词】（指定分数）" ： 分数值 int
             }
         }
     }
    ````

    ````
    {
        "query" : {
            "bool" : {
                "should【关键词】(应该满足这些条件或 OR 只要满足其中一个条件 must表示and 满足其中所有条件 must_not 一定不能满足)" : [
                    {
                        "match" : {
                            "属性名1" : "属性值1",
                        }
                    },
                    {
                        "match" : {
                            "属性名2" : "属性值2",
                        }
                    }
                ]
            }
        }
    }
    ````

* 定制返回结果

    ````
    _source_field
    ````

* 嵌套查询

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

* like 以下为数组 应转为json 放在"bool"中 

    ````
    "must" => [
    			[
    				"wildcard" => [
    				$field => '*' . $condition . '*'
    			]
    		]
    ````

* Between "bool" : {...}

    ````
    'filter' => [
    			'range' => [
    				$field => [
    					'egt' => $condition[0],
    					'elt' => $condition[1]
    				]
    			]
    		]
    ````

* in "bool" : {...}

    ````
     "must" => [
    			'nested' => [
    				"path" => $fieldArr[0],
    				"query" => [
    					"bool" => [
    						"must" => [
    							"terms" => [
    								$field => $condition
    								]
    							]
    						]
    					]
    				]
    			]
    ````

* 范围搜索 "bool" : {....}

    ````
    'must' => [
    			'geo_distance' => [
    				'distance' => $condition['distance'],
    				$field => [
    					'lat' => $condition['lat'],
    					'lon' => $condition['lon']
    				]
    			]
    		]
    ````

* sort 排序 "sort" :{...}

    ````
    //距离排序
    '_geo_distance' => [
    				(string)$field => [
    					'lat' => "$lat",
    					'lon' => "$lon"
    				],
    				'order' => "asc/desc",
    				'unit' => 'm(单位)',
    				'distance_type' => 'plane',
    			]
    
    //普通排序
    
    $data[(string)$field] = ['order' => (string)$sortType];
    ````

* bulk批量操作 _bulk

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

    > 除删除外每条操作前面必须跟{"index":{"_index":"索引名","_type":"类型","_id":"x"}}
    >
    > 每一段json不能换行，第二段之间不能有空行 每行换行'\n'
    >
    > 前6行为添加 三条数据，7-8为更新，9为删除



## 字段类型(elasticsearch6.0)

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
* 有时候我们搜索的时候需要把一个字段的类型定义为full-text，当排序的时候又需要把它当做keyword类型，这个时候我们就需要使用Multi-Fields类型了，[使用参考](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html)，可以使用[fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html)来对大部分类型做Multi-Fields处理。

__格式如下：__

````
    "properties": {
                "city": {
                      "type": "text",
                      "fields": {
                            "raw": { 
                                  "type":  "keyword"
                             }
                        }
                    }

   }
````



### 核心数据类型 

* 字符串 - text

  用于全文索引，该类型的字段将通过分词器进行分词，最终用于构建索引

* 字符串 - keyword

  不分词，只能搜索该字段的完整的值，只用于 filtering

* 数值型

  long：有符号64-bit integer：-2^63 ~ 2^63 - 1
  integer：有符号32-bit integer，-2^31 ~ 2^31 - 1
  short：有符号16-bit integer，-32768 ~ 32767
  byte： 有符号8-bit integer，-128 ~ 127
  double：64-bit IEEE 754 浮点数
  float：32-bit IEEE 754 浮点数
  half_float：16-bit IEEE 754 浮点数
  scaled_float

* 布尔 - boolean

  值：false, "false", true, "true"

* 日期 - date

  由于Json没有date类型，所以es通过识别字符串是否符合format定义的格式来判断是否为date类型
  format默认为：strict_date_optional_time||epoch_millis format

* 二进制 - binary

  该类型的字段把值当做经过 base64 编码的字符串，默认不存储，且不可搜索

* 范围类型

  范围类型表示值是一个范围，而不是一个具体的值
  譬如 age 的类型是 integer_range，那么值可以是  {"gte" : 10, "lte" : 20}；搜索 "term" : {"age": 15} 可以搜索该值；搜索 "range": {"age": {"gte":11, "lte": 15}} 也可以搜索到
  range参数 relation 设置匹配模式

INTERSECTS ：默认的匹配模式，只要搜索值与字段值有交集即可匹配到
WITHIN：字段值需要完全包含在搜索值之内，也就是字段值是搜索值的子集才能匹配
CONTAINS：与WITHIN相反，只搜索字段值包含搜索值的文档

integer_range
float_range
long_range
double_range
date_range：64-bit 无符号整数，时间戳（单位：毫秒）
ip_range：IPV4 或 IPV6 格式的字符串

### 中文分词器安装

选择适合的版本 下载

````
https://github.com/medcl/elasticsearch-analysis-ik/releases
````

在你的es安装目录中的plugin中新建ik目录

解压下载的elasticsearch-analysis-ik-6.2.4内容copy到ik中

##### 自定义词典

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

#### 分词器

* standard 分词器：英文的处理能力同于StopAnalyzer.支持中文采用的方法为单字切分。他会将词汇单元转换成小写形式，并去除停用词和标点符号

* simple 分词器：功能强于WhitespaceAnalyzer, 首先会通过非字母字符来分割文本信息，然后将词汇单元统一为小写形式。该分析器会去掉数字类型的字符

* Whitespace 分词器：仅仅是去除空格，对字符没有lowcase化,不支持中文； 并且不对生成的词汇单元进行其他的规范化处理。

* Stop 分词器：StopAnalyzer的功能超越了SimpleAnalyzer，在SimpleAnalyzer的基础上增加了去除英文中的常用单词（如the，a等），也可以更加自己的需要设置常用单词；不支持中文

* keyword 分词器：KeywordAnalyzer把整个输入作为一个单独词汇单元，方便特殊类型的文本进行索引和检索。针对邮政编码，地址等文本信息使用关键词分词器进行索引项建立非常方便。

* pattern 分词器：一个pattern类型的analyzer可以通过正则表达式将文本分成"terms"(经过token Filter 后得到的东西 )。接受如下设置:

  一个 pattern analyzer 可以做如下的属性设置:

  lowercaseterms是否是小写. 默认为 true 小写.pattern正则表达式的pattern, 默认是 \W+.flags正则表达式的flagsstopwords一个用于初始化stop filter的需要stop 单词的列表.默认单词是空的列表

* language 分词器：一个用于解析特殊语言文本的analyzer集合。不支持中文。

* snowball 分词器：一个snowball类型的analyzer是由standard tokenizer和standard filter、lowercase filter、stop filter、snowball filter这四个filter构成的。

  snowball analyzer 在Lucene中通常是不推荐使用的。

* Custom 分词器：是自定义的analyzer。允许多个零到多个tokenizer，零到多个 Char Filters. custom analyzer 的名字不能以 "_"开头.

  The following are settings that can be set for a custom analyzer type:

  SettingDescriptiontokenizer通用的或者注册的tokenizer.filter通用的或者注册的token filterschar_filter通用的或者注册的 character filtersposition_increment_gap距离查询时，最大允许查询的距离，默认是100

* ik-analyzer：中文分词器，需要手动安装。

### 倒排索引

倒排索引是由分词的词条组成

### 分片/副本

分片：大量文档时，可分为较小的分片，每个分片都是一个独立的Apache Lucene索引；

* 更多分片使索引能传到更多的服务器，可并行处理更多文件；
* 更多分片导致每个分片的资源量减少，处理效率提高；
* 更多分片会导致搜索是面临更多问题，因为必须从更多分片中合并结果，使得查询的聚合阶段需要更多资源；

> 分片数 视情况而定，默认值是一个不错的选择；

副本：为提高查询的吞吐量或实现高可用可以时用副本，副本是一个分片的精确复制

### 高亮我们的搜索

很多应用喜欢从每个搜索结果中**高亮(highlight)**匹配到的关键字，这样用户可以知道为什么这些文档和查询相匹配。在Elasticsearch中高亮片段是非常容易的。

让我们在之前的语句上增加`highlight`参数：

````
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
````

 当我们运行这个语句时，会命中与之前相同的结果，但是在返回结果中会有一个新的部分叫做`highlight`，这里包含了来自`about`字段中的文本，并且用`<em></em>`来标识匹配到的单词。

````
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
````
## 结合PHP

* 安装elasticSearch PHP扩展(注意版本)

  `` "elasticsearch/elasticsearch": "~6.0" ``

### ERROR

* No handler for type [string] declared on field [first_name]"}

  * 表示elasticsearch6.0里面不支持string类型，只有text、keyword类型

*  Result window is too large, from + size must be less than or equal to: [10000] 

   * ES提示我结果窗口太大了，目前最大值为10000，而我却要求给我10000000。并且在后面也提到了要求我修改`index.max_result_window`参数来增大结果窗口大小。

   ````
   curl -XPUT http://127.0.0.1:9200/indexName/_settings -d '{ "index" : { "max_result_window" : 100000000}}'
   ````

   

