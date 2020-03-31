# Kong

## Install

### kong

````
yum install -y https://kong.bintray.com/kong-community-edition-rpm/centos/7/kong-community-edition-0.13.1.el7.noarch.rpm
````

### PostgreSQL

安装

````
wget https://ftp.postgresql.org/pub/source/v9.6.3/postgresql-9.6.3.tar.gz
tar -zxvf postgresql-9.6.3.tar.gz
cd postgresql-9.6.3
./configure --prefix=/usr/local/postgresql --without-readline
make && make install
useradd postgres
cd /usr/local/postgresql
mkdir data
mkdir logs
cd ..
chown postgres:postgres postgresql -R
````

 配置

vim /etc/profile

````
# postgresql
export PGHOME=/usr/local/postgresql
export PGDATA=/usr/local/postgresql/data
export PGLIB=/usr/local/postgresql/lib
export PATH=$PGHOME/bin:$PATH
````

source /etc/profile

````
su postgres
initdb -D /usr/local/postgresql/data/
pg_ctl -D /usr/local/postgresql/data/ -l /usr/local/postgresql/logs/logfile start
````

日志:

````
tail -f /usr/local/postgresql/logs/logfile
````

Error:

LOG:  could not bind Unix socket: 地址已在使用
HINT:  Is another postmaster already running on port 5432? If not, remove socket file "/tmp/.s.PGSQL.5432" and retry.
WARNING:  could not create Unix-domain socket in directory "/tmp"
FATAL:  could not create any Unix-domain sockets
LOG:  database system is shut down

解决方案
rm -rf /tmp/.s.PGSQL.5432
pg_ctl -D /usr/local/postgresql/data/ -l /usr/local/postgresql/logs/logfile start
    ````

授权访问：

​    vim /usr/local/postgresql/data/postgresql.conf

````
listen_addresses = '*' 
````

停止 `` pg_ctl stop``

启动 `` pg_ctl -D /usr/local/postgresql/data/ -l /usr/local/postgresql/logs/logfile start``

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

导出数据：

`````
pg_dump -U kong kong -f kong.sql
`````

导入数据：

````
psql -d kong -U kong -f kong.sql
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
admin_listen = 内网IP:8001, 内网IP:8444 ssl
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



修改kong错误返回格式

vim /usr/local/share/lua/5.1/kong/tools/responses.lua

````
      encoded, err = cjson.encode(type(content) == "table" and content or
                                  --{message = content})--
                                  {msg = content, code = status_code})
````

修改错误内容

/usr/local/share/lua/5.1/kong/core/handler.lua

````
          --return responses.send_HTTP_NOT_FOUND("no route and no API found with those values")--
          return responses.send_HTTP_NOT_FOUND("没有找到")
````



### 参数详解：

kong.config

#### 常规属性

**prefix**

> 工作目录。相当于Nginx的前缀路径，包含临时文件和日志。每个流程必须有一个单独的工作目录
>
> 默认 ``/usr/local/kong`
> 

----

**log_level**

> Nginx服务器的日志级别
>
> 默认 ``notice``

----

proxy_access_log**

> 代理端口请求访问日志的路径。设置为`off`以禁用日志代理请求。如果这个值是相对路径，那么它将被放置于前缀路径之下。
>
> 默认：`logs/access.log`

----

proxy_error_log**

> 代理端口请求错误日志的路径。这些日志的粒度由`log_level`指令进行调整。
>
> 默认：`logs/error.log`

----

admin_access_log**

> Admin API的路径请求访问日志。设置为`off`以禁用Admin API请求日志。如果这个值是相对路径，那么它将被放置于前缀路径之下
>
> 默认：`logs/admin_access.lo`

----

admin_error_log**

> Admin API请求错误日志的路径。这些日志的粒度由log_level指令进行调整。
>
> 默认：`logs/error.log`

----

**custom_plugins**

> 这个节点应该加载的附加插件的逗号分隔列表。使用这个属性来加载与Kong不捆绑的定制插件。插件将从`kong.plugins.{name}.*`命名空间加载
>
> 默认：`none`
> 示例：`my-plugin,hello-world,custom-rate-limiting`

----

**anonymous_reports**

> 发送匿名的使用数据，比如错误堆栈跟踪，以帮助改进Kong。
>
> 默认：`on`



#### Nginx属性

**proxy_listen**

> 代理服务侦听的地址和端口的逗号分隔的列表。代理服务是Kong的公共入口点，它代理从您的使用者到您的后端服务的流量。这个值接受IPv4、IPv6和主机名
>
> 查看 <http://nginx.org/en/docs/http/ngx_http_core_module.html#listen> 用于描述这个和其他`*_listen`值的接受格式。
>
> 默认：`0.0.0.0:8000, 0.0.0.0:8443 ssl`
>  示例：`0.0.0.0:80, 0.0.0.0:81 http2, 0.0.0.0:443 ssl, 0.0.0.0:444 http2 ssl

----

**admin_listen**

> 管理接口监听的地址和端口的逗号分隔的列表。Admin接口是允许您配置和管理Kong的API。对该接口的访问应该仅限于Kong管理员。这个值接受IPv4、IPv6和主机名。可以为每一对指定一些后缀
>
> 这个值可以被设置为`off`，从而禁用这个节点的Admin接口，从而使“数据面板”模式（没有配置功能）从数据库中拉出它的配置更改。
>
> 默认：`127.0.0.1:8001, 127.0.0.1:8444 ssl`
> 示例：`127.0.0.1:8444 http2 ssl`

----

nginx_user**

> 定义工作进程使用的用户和组凭据。如果省略组，则使用名称与用户名相同的组。
>
> 默认：`nobody nobody`
> 示例：`nginx www`

----

nginx_worker_processes**

> 确定Nginx生成的工作进程的数量。请参阅<http://nginx.org/en/docs/ngx_core_module.html#worker> 流程，以便详细使用该指令和对已接受值的描述。
>
> 默认值:`auto`

----

nginx_daemon**

> 确定Nginx是否会作为守护进程或前台进程运行。主要用于开发或在Docker环境中运行Kong。
>
> 查阅 <http://nginx.org/en/docs/ngx_core_module.html#daemon>.
>
> 默认：`on`

----

mem_cache_size**

> 数据库实体内存缓存的大小。被接受的单位是k和m，最低推荐值为几个MBs。
>
> 默认：`128m`

----

ssl_cipher_suite**

> 定义Nginx提供的TLS密码。可接受的值`modern`, `intermediate`, `old`, or `custom`。请参阅 <https://wiki.mozilla.org/Security/Server_Side_TLS>
> ，了解每个密码套件的详细描述。
>
> 默认值：`modern`

----

ssl_ciphers**

> 定义一个由Nginx提供的LTS ciphers的自定义列表。这个列表必须符合`openssl ciphers`定义的模式。如果`ssl_cipher_suite`不是`custom`，那么这个值就会被忽略。
>
> 默认值：`none`

----

admin_ssl_cert_key**

启用了SSL后， `admin_listen` 的SSL key的绝对路径。

默认值：`none`

----

**upstream_keepalive**

在每个工作进程，设置缓存中保存的upstream服务的空闲keepalive连接的最大数量。当超过这个数字时，会关闭最近最少使用的连接。

默认值：`60`

------

**server_tokens**

在错误页面，和`Server`或`Via`（如果请求被代理）的响应头字段，启用或禁用展示Kong的版本。

默认值：`on`

------

**latency_tokens**

在`X-Kong-Proxy-Latency`和`X-Kong-Upstream-Latency`响应头字段中，启用或禁用展示Kong的潜在信息。

默认值：`on`

------

**trusted_ips**

定义可信的IP地址块，使其知道如何发送正确的 `X-Forwarded-*` 头部信息。来自受信任的ip的请求使Kong转发他们的 `X-Forwarded-*` headers upstream。不受信任的请求使Kong插入自己的 `X-Forwarded-*` headers。

该属性还在Nginx配置中设置 `set_real_ip_from`  指令（s）。它接受相同类型的值（CIDR块），但它是一个逗号分隔的列表。

如果相信 *all* /!\ IPs，请把这个值设为`0.0.0.0/0,::/0`。

如果特殊值`unix:`被指定了，所有的unix域套接字都将被信任。

查阅  [the Nginx docs](http://nginx.org/en/docs/http/ngx_http_realip_module.html#set_real_ip_from) 了解 更详细的`set_real_ip_from`配置资料。

Default: `none`

------

**real_ip_header**

定义请求头字段，它的值将被用来替换客户端地址。在Nginx配置中使用相同名称的指令 [ngx_http_realip_module](http://nginx.org/en/docs/http/ngx_http_realip_module.html) 设置该值。

如果这个值接收到 `proxy_protocol`，那么 `proxy_protocol` 参数将被附加到Nginx模板的 `listen` 指令中。

查阅 [the Nginx docs](http://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header) 寻找更详细的描述。

默认值： `X-Real-IP`

------

**real_ip_recursive**

该值设置了Nginx配置中同名的  [ngx_http_realip_module](http://nginx.org/en/docs/http/ngx_http_realip_module.html) 指令。

查阅 [the Nginx docs](http://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_recursive) 寻找更详细的描述。

默认值： `off`

------

**client_max_body_size**

指定在 Content-Length 的请求头中，定义Kong代理的请求的最大被允许的请求体大小。如果请求超过这个限度，Kong将返回413(请求实体太大)。将该值设置为0将禁用检查请求体的大小。

提示: 查阅关于  [the Nginx docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) 这个参数的进一步描述。数值可以用`k`或`m`后缀，表示限制是千字节，还是兆字节。

默认值：`0`

------

**client_body_buffer_size**

定义读取请求主体的缓冲区大小。如果客户端请求体大于这个值，则阀体将被缓冲到磁盘。请注意，当阀体被缓冲到磁盘的时候，访问或操纵请求主体可能无法工作，因此最好将这个值设置为尽可能高的值。（例如，将其设置为`client_max_body_size`，以迫使请求体保持在内存中）。请注意，高并发性环境需要大量的内存分配来处理许多并发的大型请求体。

提示: 查阅关于 [the Nginx docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size) 这个参数的进一步描述。数值可以用`k`或`m`后缀，表示限制是千字节，还是兆字节。

默认值：`8k`

------

**error_default_type**

当请求Accept标头丢失时，使用默认的MIME类型，且Nginx为这个请求返回一个错误。可接受的值包括 `text/plain`, `text/html`, `application/json`, 和`application/xml`.

默认值：`text/plain



#### 添加service

请求地址：*/service/*
 请求方法：*POST*
 请求主体：

| 属性                    | 描述                                                         |
| ----------------------- | ------------------------------------------------------------ |
| name（可选）            | 服务名称.                                                    |
| protocol                | 该协议用于与upstream通信。它可以是http（默认）或https。      |
| host                    | upstream服务器的主机。                                       |
| port                    | upstream服务器端口。默认为80                                 |
| path（可选）            | 在向upstream服务器请求中使用的路径。默认为空。               |
| retries（可选）         | 在代理失败的情况下执行的重试次数。默认值是5。                |
| connect_timeout（可选） | 建立到upstream服务器的连接的超时时间。默认为60000。          |
| write_timeout（可选）   | 将请求发送到upstream服务器的两个连续写操作之间的超时时间。默认为60000。 |
| read_timeout（可选）    | 将请求发送到upstream服务器的两个连续读取操作之间的超时时间。默认为60000。 |
| url（简写属性）         | 将协议、主机、端口和路径立即设置成简短的属性。这个属性是只写的（管理API从来不“返回”url）。 |



#### 添加upstream

**请求主体**

| 属性                                                 | 描述                                                         |
| ---------------------------------------------------- | ------------------------------------------------------------ |
| `name`                                               | 这是一个主机名, 必须是Service的`host`                        |
| `slot` *可选*                                        | 负载均衡器算法中的槽数 (`10`-`65536`, 默认： `1000`).        |
| `hash_on` *可选*                                     | hash值对象: `none`, `consumer`, `ip`, 或者`header` (默认： `none` 是一个加权循环方案). |
| `hash_fallback` *可选*                               | `hash_on`对象输入失败时处理: `none`, `consumer`, `ip`, 或者`header` (默认 `none`). |
| `hash_on_header` *半可选*                            | 头部作为hash的名称(当 `hash_on` 设置为 `header`时需要).      |
| `hash_fallback_header`*半可选*                       | 头部hash失败时备选方案.                                      |
| `healthchecks.active.timeout`*可选*                  | 套接字健康检查超时时间(以秒为单位).                          |
| `healthchecks.active.concurrency`*可选*              | 健康检查中要同时检查的目标数量。                             |
| `healthchecks.active.http_path`*可选*                | 探测活动健康检查的访问路径.                                  |
| `healthchecks.active.healthy.interval`*可选*         | 健康检查之间的间隔(以秒为单位)。值为0表示不执行              |
| `healthchecks.active.healthy.http_statuses`*可选*    | 一个HTTP状态数组，表示在健康检查中返回时的成功状态           |
| `healthchecks.active.healthy.successes`*可选*        | `healthchecks.active.healthy.http_statuses`返回成功的数量    |
| `healthchecks.active.unhealthy.interval`*可选*       | 检查失败目标的间隔时间(秒). 0表示不检查                      |
| `healthchecks.active.unhealthy.http_statuses`*可选*  | 一个HTTP状态数组，表示在健康检查中返回时的失败状态           |
| `healthchecks.active.unhealthy.tcp_failures`*可选*   | 返回TCP失败的数量                                            |
| `healthchecks.active.unhealthy.timeouts`*可选*       | 失败目标的超时次数                                           |
| `healthchecks.active.unhealthy.http_failures`*可选*  | `healthchecks.active.unhealthy.http_statuses`返回失败状态的数量. |
| `healthchecks.passive.healthy.http_statuses`*可选*   | 被动检查.                                                    |
| `healthchecks.passive.healthy.successes`*可选*       | 被动检查                                                     |
| `healthchecks.passive.unhealthy.http_statuses`*可选* | 被动检查.                                                    |
| `healthchecks.passive.unhealthy.tcp_failures`*可选*  | 被动检查                                                     |
| `healthchecks.passive.unhealthy.timeouts`*可选*      | 被动检查.                                                    |
| `healthchecks.passive.unhealthy.http_failures`*可选* | 被动检查.                                                    |

## 转换规则

将RoutePath 部分替换成对应ServicePath + 多出url路径

* RoutePath全部匹配

  > 解释：请求URL（/Part1/Contrall/Action）匹配上，替换成对应的Service设置的Path（/Controller/Action），最终：Upstream/Controller/Action

  Request:	www.api.com/part1/Controller/Action	

  Route:		www.api.com/part1/Controller/Action

  Service: 	/Controller/Action

  最终:		Upstream/Controller/Action

* RoutePath部分匹配

  > 解释：请求URL（/Part1）匹配上，替换成对应的service设置的Path（/）加上剩余路径部分（Controller/Action），最终：upstream/Controller/Action

  Request:	www.api.com/part1/Controller/Action	

  Route:		www.api.com/part1

  Service:	  /

  最终：		Upstream/Controller/Action

* RoutePath部分匹配

  >解释：请求URL（Part1/Controller）匹配上，替换成对应的service设置的path（/Controller）加上剩余部分（Action），最终Upstream/Controller/Action

  Request:	www.api.com/part1/Controller/Action

  Route:		www.api.com/part1/Controller

  Service:	/Controller

  最终:		Upstream/Controller/Action	