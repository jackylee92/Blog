[TOC]



__maxwell-1.10.7.tar.gz__

# install

> 需要先安装好jdk

````
tar -zxvf maxwell-1.10.7.tar.gz
mkdir /usr/local/maxwell
cp -rf maxwell-1.10.7/* /usr/local/maxwell/
````

# msyql

> 创建maxwell数据库用户，赋予权限，开启mysql_binlog

````
create user 'search'@'localhost' identified by 'search@password1';
create user 'search'@'%' identified by 'search@password1';
grant all on osp.* to 'search'@'localhost';
GRANT SELECT, REPLICATION CLIENT,REPLICATION SLAVE on *.* to 'search'@'%';
GRANT SELECT, REPLICATION CLIENT,REPLICATION SLAVE on *.* to 'search'@'localhost';
flush privileges;

vim /etc/my.cnf =>开启binlog日志
````

# Start

	bin/maxwell --user='search' --password='search@password1' --host='192.168.91.55' --producer=kafka --kafka.bootstrap.servers=192.168.91.59:9092
> maxwell会在mysql中创建Maxwell数据库，确保数据库用户权限，maxwell会自动解析binlog日志，
> maxwell会将binlog解析，转为json发送给kafka,kafka通过logstash处理日志将日志传给es

# config

* config.properties 基本配置

````
log_level=info
producer=kafka
kafka.bootstrap.servers=192.168.91.59:9092
# mysql login info
host=192.168.91.55 
user=msyql_user
password=msyql_pwd
````

* host=192.168.91.55

  > 指定从哪个地址的mysql获取binlog

* replication_host=192.168.91.55

  > 如果指定了 `replication_host`，那么它是真正的binlog来源的mysql server地址，而那么上面的`host`用于存放maxwell表结构和binlog位置的地址。
  > 将两者分开，可以避免 replication_user 往生产库里写数据。

* schema_host=192.168.91.55

  > 从哪个host获取表结构。binlog里面没有字段信息，所以maxwell需要从数据库查出schema，存起来。
  > schema_host一般用不到，但在binlog-proxy场景下就很实用。比如要将已经离线的binlog通过maxwell生成json流，于是自建一个mysql server里面没有结构，只用于发送binlog，此时表机构就可以制动从 `schema_host` 获取。

* gtid_mode=

  > 如果 mysql server 启用了GTID，maxwell也可以基于gtid取event。如果mysql server发生failover，maxwell不需要手动指定newfile:postion

正常情况下，replication_host 和 schema_host都不需要指定，只有一个 `--host`。

* schema_database=maxwell

  > 使用这个db来存放 maxwell 需要的表，比如要复制的databases, tables, columns, postions, heartbeats.

* include_dbs=user,product

  > 只发送binlog里面这些databases的变更，以`,`号分隔，中间不要包含空格。
  > 也支持java风格的正则，如 `include_tables=db1,/db\\d+/`，表示 db1, db2, db3…这样的。（下面的filter都支持这种regex）
  > 提示：这里的dbs指定的是真实db。比如binlog里面可能 `use db1` 但 `update db2.ttt`，那么maxwell生成的json `database` 内容是db2。

* exclude_dbs=user,product

  > 排除指定的这些 databbases

* include_tables=user,product

  > 只发送这些表的数据变更。不只需要指定 database.

* exclude_tables=user,product

  > 排除指定的这些表

* exclude_columns=name,ages

  > 不输出这些字段。如果字段名在row中不存在，则忽略这个filter。

* output_ddl=false

  > 是否在输出的json流中，包含ddl语句。**默认 false**

* output_binlog_position=false

  > 是否在输出的json流中，包含binlog filename:postion。默认 false

* output_commit_info=false

  > 是否在输出的json流里面，包含 commit 和 xid 信息。默认 true
  > 比如一个事物里，包含多个表的变更，或一个表上多条数据的变更，那么他们都具有相同的 xid，最后一个row event输出 commit:true 字段。这有利于消费者实现 事务回放，而不仅仅是行级别的回放。

* output_thread_id=false

  > 同样，binlog里面也包含了 thread_id ，可以包含在输出中。默认 false
  > 消费者可以用它来实现更粗粒度的事务回放。还有一个场景是用户审计，用户每次登陆之后将登陆ip、登陆时间、用户名、thread_id记录到一个表中，可轻松根据thread_id关联到binlog里面这条记录是哪个用户修改的。

* init_position=

  > 手动指定maxwell要从哪个binlog，哪个位置开始。指定的格式`FILE:POSITION:HEARTBEAT`。只支持在启动maxwell的命令指定，比如 `--init_postion=mysql-bin.0000456:4:0`。
  >
  > maxwell 默认从连接上mysql server的当前位置开始解析，如果指定 init_postion，要确保文件确实存在。这个配置只能写在命令后面，写在配置文件中没有生效。

* producer=file/kafka/rabbitmq/redis

  > 输出到哪里

File:

* output_file=/tmp/mysql_binlog_data.log

  > 输出到file的指定位置

Kafka:

* kafka.bootstrap.servers=hosta:9092,hostb:9092

  > 输出到kafka

* kafka_topic=maxwell

  > 输出到kafka的某一个topic

* ddl_kafka_topic=maxwell_ddl

  > 输出到kafka ddl保存在某一个topic

* producer_partition_by=database

  > kafka和kenesis都支持分区，可以选择根据 database, table, primary_key, 或者column的值去做partition
  >
  > maxwell默认使用database，在启动的时候会去检查是否topic是否有足够多数量的partitions，所以要提前创建好
  >
  > bin/kafka-topics.sh --zookeeper ZK_HOST:2181 --create  --topic maxwell --partitions 20 --replication-factor 2

* producer_partition_columns=user_id,create_date

  > 如果指定了 producer_partition_by=column, 就需要指定下面两个参数 
  >
  > 根据user_id,create_date两列的值去分区，partition_key形如 1178532016-10-10 18:29:04

* producer_partition_by_fallback=database

  > 如果不存在user_id或create_date，则按照database分区:

Rabbitmq:

````
producer=rabbitmq

rabbitmq_host=10.81.xx.xxx
rabbitmq_user=admin
rabbitmq_pass=admin
rabbitmq_virtual_host=/some0
rabbitmq_exchange=maxwell.some
rabbitmq_exchange_type=topic
rabbitmq_exchange_durable=true
rabbitmq_exchange_autodelete=false
rabbitmq_routing_key_template=%db%.%table%
````

Redis:

````
producer=redis

redis_host=10.47.xx.xxx
redis_port=6379
# redis_auth=redis_auth
redis_database=0
redis_pub_channel=maxwell
````

## QA

* INFO  BinaryLogClient - Connected to 192.168.92.55:3306 at mysql-bin.000002/15173148

  >  maxwell读取binlog未知错误，该位置记录在mysql中maxwell position表中，删除该表；或者清除binlog(reset master) ,然后执行启动命令；
  >
  > ````
  > # mysql
  > 查看binlog ：show master logs
  > 查看binlog内容：show binlog events;
  > 查看指定binlog内容：show binlog events in 'mysql-bin.000002';
  > 条件查新：SHOW BINLOG EVENTS IN 'mysql-bin.000005' FROM 194 LIMIT 2 \G;
  > ````

* maxwell 不指定读取位置，每次都会从maxwell会从开始连上mysql的位置读取binlog，命令后追加 --init_position=mysql-bin.000003:19573225:0 设置读取位置；该位置可以在mysql中通过：show master status获取当前位置；

* tableMapCache

  > 问题是：如果我需要获取某一个表的变更，这个表现在删除了，但是我启动maxwell读取binlog的日志是从昨天，导致现在maxwell启动的时候没有获取到这个表结构，因为这个表在启动前删了，但是读取的binlog日志是从昨天，昨天的日志中有这张表的变化记录，所有就会爆异常；也就是说maxwell的变化是依赖先获取到的表结构的；


## Maxwell监听binlog获取到的 json

````
{
    "database": "osp",
    "table": "station",
    "type": "insert",
    "ts": 1536133644,
    "xid": 1149,l
    "commit": true,
    "data": {
        "oss_id": 4,
        "osp_id": 2,
        "oss_type": 35,
        "oss_shape": 10,
        "oss_name": "逸仙路站点2",
        "oss_shortname": "逸仙路",
        "province_id": 25,
        "city_id": 0,
        "district_id": 0,
        "address": "逸仙路25号",
        "tel": "12345678",
        "opentime": "",
        "tags": "同济经度",
        "longitude": "23",
        "latitude": "45",
        "contacts_id": 10,
        "scm_id": "",
        "remark": "",
        "status": 1,
        "create_time": null,
        "update_time": "2018-09-01 07:49:01",
        "delete_flag": 0
    }
}
````