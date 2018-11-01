### Logstash

---

## logstash

### 安裝

````
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
````

````
vim /etc/yum.repos.d/logstash.repo
[logstash-5.x]
name=Elastic repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
````

````
yum install logstash
````

或

````
 wget https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0.tar.gz
````

````
tar -zxvf logstash-6.0.0.tar.gz
mkdir /use/local/logstash
cp -rf logstash-6.0.0/* /use/local/logstash/
````

````
echo "export PATH=\$PATH:/usr/local/logstash/bin" > /etc/profile.d/logstash.sh
source /etc/profile
````



### 測試

````
/usr/share/logstash/
````

````
bin/logstash -e 'input { stdin { } } output { stdout {} }'
````

等待几秒钟 出现  

The stdin plugin is now waiting for input:

然后输入

````
hello world
````

得到类似的结果

2016-11-24T08:01:55.949Z bogon hello world

>ARNING: Could not find logstash.yml which is typically located in $LS_HOME/config or /etc/logstash.
>
>解决方案：
>
>	mkdir -p /usr/share/logstash/config/
>
>	ln -s /etc/logstash/* /use/share/logstash/config



## logstash-input-jdbc插件

### 安装

````
//下载工具
yum install gem
````

进入安装目录执行以下操作 ``cd /usr/share/logstash``

````
//替换
gem sources --add http://gems.ruby-china.com/ --remove https://rubygems.org/ 
````

````
//检测是否替换成功
 gem sources -l
````

````
vim Gemfile
修改
source "http://gems.ruby-china.com/"
````

````
vim Gemfile.jruby-1.9.lock
修改
GEM
  remote: http://gems.ruby-china.com/
````

````
安装
bin/logstash-plugin install logstash-input-jdbc
````

安装成功提示：

````
Validating logstash-input-jdbc
Installing logstash-input-jdbc
Installation successful
````

https://dev.mysql.com/downloads/connector/j/

![1535989361253](https://github.com/jackylee92/Blog/blob/master/Images/mysql-connect-java001.png?raw=true)

![1535989416438](https://github.com/jackylee92/Blog/blob/master/Images/mysql-connect-java002.png?raw=true)

> MySQL Connector/J is the official JDBC driver for MySQL. MySQL Connector/J 8.0 is compatible with all MySQL versions starting with MySQL 5.5. Additionally, MySQL Connector/J 8.0 supports the new X DevAPI for development with MySQL Server 8.0

### 监听配置

vim /etc/logstash/conf.d/${name}.conf

````
input {
    file {
        #监听文件的路径
        path => ["E:/software/logstash-1.5.4/logstash-1.5.4/data/*","F:/test.txt"]
        #排除不想监听的文件
        exclude => "1.log"
        
        #添加自定义的字段
        add_field => {"test"=>"test"}
        #增加标签
        tags => "tag1"

        #设置新事件的标志
        delimiter => "\n"

        #设置多长时间扫描目录，发现新文件
        discover_interval => 15
        #设置多长时间检测文件是否修改
        stat_interval => 1

         #监听文件的起始位置，默认是end
        start_position => beginning

        #监听文件读取信息记录的位置
        sincedb_path => "E:/software/logstash-1.5.4/logstash-1.5.4/test.txt"
        #设置多长时间会写入读取的位置信息
        sincedb_write_interval => 15
        
    }
}
filter {
    
}
output {
    stdout {}
}
````

**1 path**

　　是必须的选项，每一个file配置，都至少有一个path

**2 exclude**

　　是不想监听的文件，logstash会自动忽略该文件的监听。配置的规则与path类似，支持字符串或者数组，但是要求必须是绝对路径。

**3 start_position**

　　是监听的位置，默认是end，即一个文件如果没有记录它的读取信息，则从文件的末尾开始读取，也就是说，仅仅读取新添加的内容。对于一些更新的日志类型的监听，通常直接使用end就可以了；相反，beginning就会从一个文件的头开始读取。但是如果记录过文件的读取信息，这个配置也就失去作用了。

**4 sincedb_path**

　　这个选项配置了默认的读取文件信息记录在哪个文件中，默认是按照文件的inode等信息自动生成。其中记录了inode、主设备号、次设备号以及读取的位置。因此，如果一个文件仅仅是重命名，那么它的inode以及其他信息就不会改变，因此也不会重新读取文件的任何信息。类似的，如果复制了一个文件，就相当于创建了一个新的inode，如果监听的是一个目录，就会读取该文件的所有信息。

**5**  其他的关于扫描和检测的时间，按照默认的来就好了，如果频繁创建新的文件，想要快速监听，那么可以考虑缩短检测的时间。

**6 add_field**

　　就是增加一个字段，例如：

````
file {
     add_field => {"test"=>"test"}
        path => "D:/tools/logstash/path/to/groksample.log"
        start_position => beginning
    }
````

![logstash001](https://github.com/jackylee92/Blog/blob/master/Images/logstash001.png?raw=true)

　**7 tags**

　　用于增加一些标签，这个标签可能在后续的处理中起到标志的作用

![logstash002](https://github.com/jackylee92/Blog/blob/master/Images/logstash002.png?raw=true)

　**8 delimiter**

　　是事件分行的标志，如果配置成123,那么就会如下所示。这个选项，通常在多行事件中比较有用。

![logstash003](https://github.com/jackylee92/Blog/blob/master/Images/logstash003.png?raw=true)

__官方文档__ :<https://www.elastic.co/guide/en/logstash/current/plugins-inputs-file.html#plugins-inputs-file-sincedb_path>


