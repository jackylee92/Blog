# Nginx配置

统一管理项目入口

## 添加项目

* 修改本地host文件

  ```shell
  # 域名随意
  127.0.0.1 local.xxx.com
  ```

* 添加项目配置

  > xxx.conf

  ```nginx
  server {
      listen       80;
      server_name  local.phpinfo.com;
  
      location / {
          root /usr/share/nginx/html/phpinfo;
          index index.php;
  
          if (!-e $request_filename) {
              rewrite ^/(.*) /index.php?$1 last;
          }
      }

  
      location ~ \.php$ {
          fastcgi_pass   php:9000;
          fastcgi_index  index.php;
          fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/html/phpinfo$fastcgi_script_name;
          fastcgi_param  SCRIPT_NAME      $fastcgi_script_name;
          include        fastcgi_params;
      }
      
  }
  ```
  

