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

### 结构
我们首先要做的是存储员工数据，每个文档代表一个员工。在Elasticsearch中存储数据的行为就叫做**索引(indexing)**，不过在索引之前，我们需要明确数据应该存储在哪里。

在Elasticsearch中，文档归属于一种**类型(type)**,而这些类型存在于**索引(index)**中，我们可以画一些简单的对比图来类比传统关系型数据库：

```
Relational DB -> Databases -> Tables -> Rows -> Columns
Elasticsearch -> Indices   -> Types  -> Documents -> Fields
```

每一个index都有一个Mapping来定义该index怎样去索引，需要注意的是，大体概念我们可以这样理解ES中的index和Mapping Type，index 对应SQL DB中的database，Mapping Type对应 SQL DB中的table，但是又不完全一样，因为在SQL DB中，不同table中的字段名称可以重复，但是定义可以不一样，再ES中却不可以存在这种情况，因为ES是基于Lucene,在ES映射到Lucene时，同一个index下面的不同mapping的同一字段名映射是同一个的，也就意味着，再不同的mapping中，相同字段名的类型也要保持一致

## 字段类型(elasticsearch6.0)

###基础类型：
* 字符类型： `` text、keyword``    
* 数字类型： `` long、integer、short、byte、double、float、half_float、sacled_float``     
* 日期类型： ``date``    
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




###高亮我们的搜索

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

*  No handler for type [string] declared on field [first_name]"}
  * 表示elasticsearch6.0里面不支持string类型，只有text、keyword类型
