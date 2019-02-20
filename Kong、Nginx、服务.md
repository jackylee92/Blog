[TOC]



# Kong、NGINX、服务搭建

> 前端通过url访问NGINX，NGINX通过upstream分发到kong，kong通过配置（Route指向service，service通过kong的upstream分发到对应的服务）

## 准备

* 域名：www.aaa.com
* kongIP：1.1.1.1
* 服务地址：2.2.2.2:2222/user/login 

##Nginx

>  NGINX只是一个转发，只需要配置upstream转发到kong即可

### 安装

````
yum install nginx -y
````

### 配置

vim /etc/nginx/conf.d/www.kong.com	【监控域名】

````
server {
    listen 80;
    server_name www.aaa.com;
    location / {
        proxy_pass http://www.aaa.com;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
````

vim /etc/nginx/upstream.conf	【将www.aaa.com转发到1.1.1.1服务器上的kong中】

````
upstream www.aaa.com{
    server 1.1.1.1:8000 weight=2 fail_timeout=20s;
}
````

## Kong

> Kong将Nginx转发过来的url首先通过Routes中查找，与Route中Hosts匹配
>
> 通过该条Route的Service名字找到对应的Service
>
> 通过该条Service的Host与upstream中Name匹配找到对应的upstream
>
> upstream下会有>1条的Target 会根据权重分发到这几个Targets上，该Target的地址就是具体服务所在的地址

### 安装

> 见Kong文档

### 配置服务

* 添加一个service

#### 添加service

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

或是通过Kong Dashboard

kong1.png url

#### 添加一个upstream

请求方法：*POST*
请求主体：

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

或是通过Kong Dashboard

kong2.png url

#### 添加Route

通过Kong Dashboard添加

添加入口在每一个Service上

kong3.png url



### JWT （Json Web Token）

添加JWT插件，注意添加时选择了Routes，JWT只对该Route生效

kong3.png url

这个时候访问该Route是会拦截，要求验证；

* 添加Customer

  post:

  1.1.1.1:8001/consumers 

  username : aaa

  custom_id : 100

  return :

  {
      "custom_id": "100",
      "created_at": 1550671078000,
      "username": "aaa",
      "id": "e4b7b442-caf0-4ec4-94fd-a64ba33b8aa5"
  }

* 查看添加Customer信息

  post：

  1.1.1.1:8001/consumers/aaa/jwt

  return：

  {
      "created_at": 1550671164000,
      "id": "525031c1-cf85-41a2-aa1f-c89a7c988199",
      "algorithm": "HS256",
      "key": "YiOPRXKstIMv89M5FdOZnnvSPmkEW1mY",
      "secret": "NlJS8Pu4eDNfBvKJZzjUoFcp951KzuqX",
      "consumer_id": "e4b7b442-caf0-4ec4-94fd-a64ba33b8aa5"
  }

  这其中key 、secret 重要

* 生成token


   通过https://jwt.io 可以协助生成token测试；

   kong3.png url

* 携带token请求通过

  kong6.png url






