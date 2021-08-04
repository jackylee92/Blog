# localhostlocalhostKong

## Kong Oauth2登录

* 为需要的Service添加Oauth2插件，记录``"provision_key": "4ldbbtfJoT8Q53hHvq8UhptvyXiJY1bD"``

  注意调整 **过期时间：token expiration** 、**开启授权方式：enable authorization code**

  name                    自定义名称

  service_id                 指定绑定的service

  enabled                   是否启用插件 默认true

  config.scopes                用户访问范围 String（不确定写什么）

  config.mandatory_scope           请求token中是否必须要携带scopes 默认false 

  config.token_expiration           token有效时间，单位s，设置为0则用不失效，默认7200s，30758400:一年

  config.enable_authorization_code      oauth2的四种授权方式之一，code授权方式 默认false

  config.enable_client_credentials      oauth2的四种授权方式之一，客户端授权方式 默认false

  config.enable_implicit_grant         oauth2的四种授权方式之一，静默授权方式 默认false

  config.enable_password_grant         oauth2的四种授权方式之一，密码授权方式 默认false 

  config.auth_header_name            发送请求时，请求头部携带token的参数 默认 authorization 

  config.hide_credentials            是否向service隐藏授权信息   默认false。

  config.accept_http_if_already_terminated   

  config.anonymous               可以匿名访问的用户id（kong的用户），只有在认证失败的请款下才会用到此参数

  config.global_credentials           所有的oauth2插件是否可以共用一个token，默认false

  config.refresh_token_ttl           refresh_token的失效时间 默认 1209600s 

* 用户登录发送用户名和密码到登录接口，登录接口验证账号，登录失败直接返回，登录成功继续往下走

* 通过user_id获取用户Consumer

  ```shell
  curl -i -X GET \
  --url http://localhost:8001/consumers/user_id
  ```

  返回

  ```json
  {
      "custom_id": "100",
      "created_at": 1609769373,
      "id": "e53f1216-9263-4669-81b3-1e05123d377b",
      "tags": [
          "lijundong_tag"
      ],
      "username": "test"
  }
  ```

  记录id

* 如果未获取到则创建

  ```shell
  curl -i -X POST \
  --url http://localhost:8001/consumers/ \
  --data "username=102" \
  --data "custom_id=102" \
  --data "tags=username"
  ```

  返回

  ```json
  {
      "custom_id": "102",
      "created_at": 1609948785,
      "id": "e0fc146e-1477-411b-9229-d5c2b58abeca",
      "tags": [
          "lijundong"
      ],
      "username": "102"
  }
  ```

  记录id

* 获取该用户的登录Application

  ```shell
  curl -i -X GET \
  --url http://localhost:8001/consumers/{{id}}/oauth2
  ```

  返回

  ```json
  {
      "data": [
          {
              "created_at": 1609780064,
              "id": "5f7a4bc9-d22a-480c-bf9a-f256e122a285",
              "tags": null,
              "name": "lijundong_auth2_name",
              "client_secret": "wchdQDKqS61U9r5AP8nExa3amsr5LDEk",
              "client_id": "30",
              "redirect_uris": [
                  "https://localhost:8443/public/index"
              ],
              "hash_secret": false,
              "client_type": "confidential",
              "consumer": {
                  "id": "e53f1216-9263-4669-81b3-1e05123d377b"
              }
          }
      ]
  }
  ```

* 循环data判断client_id是否该App的编号

* 如果查询到登录的Application，记录client_secret、client_id

* 如果未查询到登录的Application则创建

  url中101：表示consumer的custom_id

  name：表示App名称

  client_id：App编号_用户ID

  ```shell
  curl -i -X POST \
  --url http://localhost:8001/consumers/101/oauth2/ \
  --data "name=wechat" \
  --data "client_id=1001_1" \
  --data "redirect_uris=https://localhost:8443/public/index"
  ```

  返回

  ```json
  {
      "created_at": 1609950291,
      "id": "4b2391d9-09f8-4041-84cf-229c76eb1643",
      "tags": null,
      "name": "wechat",
      "client_secret": "KYXT3C6rcbNVbNXGWNkxty8xmmGTFDNK",
      "client_id": "1001_1",
      "redirect_uris": [
          "https://localhost:8443/public/index"
      ],
      "hash_secret": false,
      "client_type": "confidential",
      "consumer": {
          "id": "fb32ece5-a0cb-45ff-a9b8-332069100474"
      }
  }
  ```

  记录client_secret、client_id

* 获取code，请求redirect_uris并且后面加/oauth2/authorize，注意是https.

  以下必传

  client_id：为consumer的Application中的client_id

  response_type：写死``code``

  provision_key：service开启oauth2时获取到的provision_key

  authenticated_userid：用户ID

  ```shell
  curl -i -X POST \
  --url https://localhost:8443/private/index/oauth2/authorize \
  --data "client_id=1001_1" \
  --data "response_type=code" \
  --data "provision_key=4ldbbtfJoT8Q53hHvq8UhptvyXiJY1bD" \
  --data "authenticated_userid=101"
  ```

  返回

  ```json
  {"redirect_uri":"https:\/\/localhost:8443\/public\/index?code=Blu84V65wmPZOQp9mBjvwpfH4KYDVZVe"}
  ```

* 获取token

  以下必传
  
  grant_type：写死``authorization_code``
  
  client_id：为consumer的Application中的client_id
  
  client_secret：为consumer的Application中的client_secret

  code：上一步获取到的code
  
  ```shell
  curl -i -X POST \
  --url https://localhost:8443/private/index/oauth2/token \
  --data "grant_type=authorization_code" \
  --data "client_id=1001_1" \
  --data "client_secret=KYXT3C6rcbNVbNXGWNkxty8xmmGTFDNK" \
  --data "code=gMqKeIgCGbUlPBe8jm91VD9CToJuWtmx"
  ```
  
  返回
  
  ```json
  {"refresh_token":"jF2dtIcxIfvTUhkHx0uTyy2MpiNTL3XO","token_type":"bearer","access_token":"6Kx8IMJmSc83GCaXIZA8B5tw0d7eUvN2","expires_in":7200}
  ```
  
* 删除Token

  ```shell
  curl -X DELETE http://localhost:8001/oauth2_tokens/{{token}}
  ```

  返回 ""， 通过httpStatus判断 204 成功

### 完整实例：

```shell
# 用户ID：999
# 用户名：jacky
# AppName: appA
# AppId: 1001

curl -i -X GET \
--url http://localhost:8001/consumers/999
# >> {"message":"Not found"}

curl -i -X POST \
--url http://localhost:8001/consumers/ \
--data "username=999" \
--data "custom_id= 999" \
--data "tags=jacky"
# >> {"custom_id":" 999","created_at":1609990536,"id":"1c333173-28c0-4303-bbc8-c09535fa57b7","tags":["jacky"],"username":"999"}

curl -i -X GET \
--url http://localhost:8001/consumers/1c333173-28c0-4303-bbc8-c09535fa57b7/oauth2
# >> {"next":null,"data":[]}

curl -i -X POST \
--url http://localhost:8001/consumers/999/oauth2/ \
--data "name=appA" \
--data "client_id=1001_999" \
--data "redirect_uris=https://localhost:8443/public/index"
# >> {"created_at":1609990769,"id":"55bece24-c27c-4c1c-930e-6b6fc06eff04","tags":null,"name":"appA","client_secret":"kcuRUBnGxZ4QCcr8eZ4injdSKFk3tOR6","client_id":"1001_999","redirect_uris":["https:\/\/localhost:8443\/public\/index"],"hash_secret":false,"client_type":"confidential","consumer":{"id":"1c333173-28c0-4303-bbc8-c09535fa57b7"}}

curl -i -X POST \
--url https://localhost:8443/private/index/oauth2/authorize \
--data "client_id=1001_999" \
--data "response_type=code" \
--data "provision_key=4ldbbtfJoT8Q53hHvq8UhptvyXiJY1bD" \
--data "authenticated_userid=999"
# >> {"redirect_uri":"https:\/\/localhost:8443\/public\/index?code=w5kmaM1zoueR2r4fihxDQ47vv5gVERrx"}

curl -i -X POST \
--url https://localhost:8443/private/index/oauth2/token \
--data "grant_type=authorization_code" \
--data "client_id=1001_999" \
--data "client_secret=kcuRUBnGxZ4QCcr8eZ4injdSKFk3tOR6" \
--data "code=w5kmaM1zoueR2r4fihxDQ47vv5gVERrx"
# >> {"refresh_token":"vTZaSKTKxRaSyRLEUpK2mlFz0tMRh1ue","token_type":"bearer","access_token":"TJkKntxGc9l0slMhZhlxHz4iJhn5seQO","expires_in":7200}

curl -i -X POST \
--url https://localhost:8443/private/index \
--header "Authorization: bearer TJkKntxGc9l0slMhZhlxHz4iJhn5seQO"
# >> {"File":{"Body":"","Name":""},"Method":"POST","URI":"/private/index","UniqID":"bvr8aer202q50j1ejbb0","RequestTime":"2021-01-07 11:51:23","ResponseTime":"2021-01-07 11:51:23","Header":{"Accept":["*/*"],"Authorization":["bearer TJkKntxGc9l0slMhZhlxHz4iJhn5seQO"],"Connection":["keep-alive"],"User-Agent":["curl/7.29.0"],"X-Authenticated-Userid":["999"],"X-Consumer-Custom-Id":["999"],"X-Consumer-Id":["1c333173-28c0-4303-bbc8-c09535fa57b7"],"X-Consumer-Username":["999"],"X-Credential-Identifier":["1001_999"],"X-Forwarded-For":["47.97.206.158"],"X-Forwarded-Host":["localhost"],"X-Forwarded-Path":["/private/index"],"X-Forwarded-Port":["8443"],"X-Forwarded-Prefix":["/private"],"X-Forwarded-Proto":["https"],"X-Real-Ip":["47.97.206.158"]},"Param":{},"Out":{"code":0,"msg":"url not found","data":null}}
```

