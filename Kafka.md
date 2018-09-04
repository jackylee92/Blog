# Kafka

* wget http://mirror.bit.edu.cn/apache/kafka/1.0.0/kafka_2.11-1.0.0.tgz

* tar -zxvf kafka_2.11-1.0.0.tgz

* cd kafka_2.11-1.0.0

* vim config/server.properties

  ````
  //無所謂修改下log目錄
  log.dirs=/data/kafka/kafka-logs
  ````

* mkdir /data/kafka

* bin/zookeeper-server-start.sh -daemon config/zookeeper.properties

* bin/kafka-server-start.sh config/server.properties

java.net.ConnectException: 拒绝连接 JavaThread "Unknown thread"  kafka 

解决方案：先启动bin/zookeeper-server-start.sh -daemon config/zookeeper.properties

10.211.55.2

Kafka:

````
//启动zookeeper
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
````

````
//java.net.ConnectException: 拒绝连接、创建tipic
bin/kafka-topics.sh --create --zookeeper 10.211.55.2:2181 --replication-factor 1 --partitions 1 --topic maxwell

bin/kafka-topics.sh --create --zookeeper 10.211.55.2:2181 --replication-factor 1 --partitions 1 --topic maxwell
````

````
bin/kafka-server-start.sh config/server.properties
````

````
//启动生产者窗口
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic maxwell
````

````
//启动消费者
bin/kafka-console-consumer.sh--zookeeper mw:2181 --topic maxwell --from-beginning
````

Maxwell:

````
bin/maxwell --user='maxwell' --password='maxwell@password1' --host='10.211.55.7' --producer=kafka --kafka.bootstrap.servers=10.211.55.7:9092
````

Log stash:

````
systemctl start logstash
````

查看topic list

````
bin/kafka-topics.sh --zookeeper localhost:2181 --list
````

查看某个topic 信息

````
bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic topic_name
````

如果有问题查看/data/logstash的日志



对老数据无效，新增的数据在es中存在，才会更新，老数据只会存在mysql中未同步至es中；



	