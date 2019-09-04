[TOC]

## elasticsearch

### 建立存放binlog日志的索引

````
put http://ip:9100/queue
{
    "mappings" : {
        "list" : {
            "properties" : {
            }
        }
    }
}
````

## mysql

### 创建mysql用户

````
	create user 'search'@'localhost' identified by 'search@password1';
	create user 'search'@'%' identified by 'search@password1';
	grant all on osp.* to 'search'@'localhost';
	GRANT SELECT, REPLICATION CLIENT,REPLICATION SLAVE on *.* to 'search'@'%';
	GRANT SELECT, REPLICATION CLIENT,REPLICATION SLAVE on *.* to 'search'@'localhost';
	flush privileges;
````


vim /etc/my.cnf =>开启binlog日志
## opt 准备文件

* jdk-8u171-linux-x64.tar.gz
* kafka_2.11-1.0.0.tgz
* logstash-6.0.0.tar.gz
* maxwell-1.10.7.tar.gz
* rubygems-2.6.12.zip	=>wget https://rubygems.org/rubygems/rubygems-2.6.12.zip


## install

### kafka

````
tar -zxvf kafka_2.11-1.0.0.tgz
mkdir /usr/local/kafka
cp -rf kafka_2.11-1.0.0/* /usr/local/kafka/
````

### logstash

````
tar -zxvf logstash-6.0.0.tar.gz
mkdir /usr/local/logstash
cp -rf logstash-6.0.0/* /usr/local/logstash/
echo "export PATH=\$PATH:/usr/local/logstash/bin" > /etc/profile.d/logstash.sh
source /etc/profile
bin/logstash -e 'input { stdin { } } output { stdout {} }'	=>测试
Pipelines running	=>代表成功
````


### maxwell

````
tar -zxvf maxwell-1.10.7.tar.gz
mkdir /usr/local/maxwell
cp -rf maxwell-1.10.7/* /usr/local/maxwell/

unzip rubygems-2.6.12.zip
cd rubygems-2.6.12
ruby setup.rb
echo "export PATH=\$PATH:/usr/local/logstash/vendor/jruby/bin" > /etc/profile.d/gem.sh
source /etc/profile
jgem sources --add http://gems.ruby-china.com/ --remove https://rubygems.org/ =>替换源地址
jgem sources --add https://gems.ruby-china.com/ --remove http://gems.ruby-china.com/
gem sources -l	=>查看原地址，保证只有一个
````

vim /usr/local/logstash/Gemfile

````
source "https://gems.ruby-china.com/"
````

vim /usr/local/logstash/Gemfile.jruby-2.3.lock

````
GEM
	remote: https://gems.ruby-china.com/
````

执行：

````
/usr/local/logstash/bin/logstash-plugin install logstash-filter-translate
/usr/local/logstash/bin/logstash-plugin install logstash-input-jdbc
````

结果：

````
Validating logstash-input-jdbc
Installing logstash-input-jdbc
Installation successful
````

## 启动

### Kafka

__启动zookeeper port:2181__

````
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
````

vim config/server.properties

````
broker.id=1 =>改了后报错 kafka无法启动
````

__启动kafka；kafka默认日志路径，默认端口:9092__

````
bin/kafka-server-start.sh config/server.properties
````

__创建maxwell topic__

````
bin/kafka-topics.sh --create --zookeeper 192.168.91.59:2181 --replication-factor 1 --partitions 1 --topic maxwell
````

__查看topic__

````
bin/kafka-topics.sh --zookeeper 192.168.91.59:2181 --list
````

__启动消费者窗口查看maxwell数据__

````
bin/kafka-console-consumer.sh --zookeeper 192.168.91.59:2181 --topic maxwell --from-beginning
````

### logstatsh

> logstash 在conf.d的配置文件中对每条json解析

>  日志:var/log/logstash/gc.log

__配置 conf.d/xxx.conf__

````
input {
	kafka {
		bootstrap_servers=> "localhost:9092"
		group_id => "logstash"
		topics=> ["maxwell"]
		codec => json {charset => ["UTF-8"]}
		consumer_threads => 5
		decorate_events => true
	}
}
filter {
	json {
		source => "message"
	}
	mutate {
		add_field=> {"status" => "0"}
	}
}
output {
	if [database] in "osp" and [table] in "station" {	//当in的参数只有一条不使用[]，多条才使用[]
		elasticsearch {
			hosts => ["192.168.91.59:9200"]
			index => "queue"
			document_type => "list"
			workers => 1
			template_overwrite => true
		}
	}else {
		stdout{
			codec => json
		}
	}
}
````

__启动logstash__

````
/usr/..../logstash/bin/logstash -f /usr/..../config/conf.d/file_more_choose.conf
````


### maxwell

__maxwell会在mysql中创建Maxwell数据库，确保数据库用户权限，maxwell会自动解析binlog日志__

````
bin/maxwell --user='search' --password='search@password1' --host='192.168.91.55' --producer=kafka --kafka.bootstrap.servers=192.168.91.59:9092
````

> maxwell会将binlog解析，转为json发送给kafka,kafka通过logstash处理日志将日志传给es
> 如果出现：INFO  BinaryLogClient - Connected to 192.168.92.55:3306 at mysql-bin.000002/15173148
> 删除数据库中maxwell中所有的表，然后在执行，因为启动maxwell后连接数据库，开始读取的binlog日志位置position是maxwell position表中查出来的，位置可能是错误的，最好清楚binlog(reset master)  然后重新执行以上命令；
> 查看binlog ：show master logs
> 查看binlog内容：show binlog events;
> 查看指定binlog内容：show binlog events in 'mysql-bin.000002';
> 条件查新：SHOW BINLOG EVENTS IN 'mysql-bin.000005' FROM 194 LIMIT 2 \G;

__Maxwell监听binlog获取到的 json__

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






