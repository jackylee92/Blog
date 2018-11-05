# Kong

## Install

### kong

````
yum install -y https://kong.bintray.com/kong-community-edition-rpm/centos/7/kong-community-edition-0.13.1.el7.noarch.rpm
````

### PostgreSQL

安装

````
yum install https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm
yum install postgresql95 postgresql95-server

````

 授权访问：

	vim /var/lib/pgsql/9.5/data/postgresql.conf

````
listen_addresses = '*' 
````

启动

````
systemctl enable postgresql-9.5
systemctl restart postgresql-9.5
````

授权kong数据库

````
# 创建postgres用户
su - postgres 
# 进入postgresql 客户端
psql;
# 创建kong用户授权
CREATE USER kong; 
CREATE DATABASE kong OWNER kong;
ALTER USER kong WITH password 'kong';
# 退出
/q
````

## 配置

kong 连接 postgresql

````
cp /etc/kong/kong.conf.default /etc/kong/kong.conf
````

vim /etc/kong/kong.conf

````
pg_host = 127.0.0.1             # The PostgreSQL host to connect to.
pg_port = 5432                  # The port to connect to.
pg_user = kong                  # The username to authenticate if required.
pg_password = kong@password                  # The password to authenticate if required.
pg_database = kong              # The database name to connect to.
pg_ssl = off                    # Toggles client-server TLS connections                                  # between Kong and PostgreSQL.

pg_ssl_verify = off             # Toggles server certificate  设置kong和postgres的连接方式
verification if
````

导入kong数据

````
kong migrations up -c /etc/kong/kong.conf
````

启动kong

````
kong start
````

## kong Dashboard

### Install

安装

````
npm install -g kong-dashboard
````

启动

````
kong-dashboard start --kong-url http://localhost:8001
#访问
ip:8080
````

用自定义端口启动 Kong Dashboard 

````
kong-dashboard start --kong-url http://localhost:8001 --port [port]
````

使用权限认证启动 Kong Dashboard

````
kong-dashboard start --kong-url http://kong:8001 --basic-auth user1=password1 user2=password2
````

