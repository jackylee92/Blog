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

