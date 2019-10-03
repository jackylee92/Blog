# Python+Selenium



## 基本概念

* chrome-Headless：是一种无浏览器窗口的模式，是Google 自己出的无头浏览器模式
* ChromeDriver：WebDriver是一个开源工具，用于在许多浏览器上自动测试webapps。 ChromeDriver 是 google 为网站开发人员提供的自动化测试接口，它是 selenium2 和 chrome浏览器 进行通信的桥梁。
* Selenium：操控浏览器

## 安装

### Chrome

首先安装google的epel源

编辑文件：

````
vim /etc/yum.repos.d/google-chrome.repo
````

输入内容如下：

````
[google]
name=Google-x86_64
baseurl=http://dl.google.com/linux/rpm/stable/x86_64
 
enabled=1
gpgcheck=0
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
````

更新yum ：

````
yum update
````

安装：

````
yum -y install google-chrome-stable --nogpgcheck
````

测试：

````
google-chrome-stable --no-sandbox --headless --disable-gpu --screenshot
````

输出：

````
[0927/063008.915324:INFO:headless_shell.cc(619)] Written to file screenshot.png.
````

查看版本：

````
google-chrome-stable --version
````

输出：

````
Google Chrome 77.0.3865.90
````

### ChromeDirver

选择Chrome版本匹配的[ChromeDirver](http://chromedriver.storage.googleapis.com/index.html)

解压获取 chromedriver 可执行文件，放入``/usr/local/bin/``下

### Selenium

先安装pip

````
yum install python-setuptools && easy_install pip
````

安装selenium

````
pip install selenium
````



## 实现

### 简单demo

````
#!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

url = 'https://www.baidu.com/'
chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--disable-dev-shm-usage')
driver = webdriver.Chrome(chrome_options=chrome_options)
driver.get(url)
html = driver.page_source
driver.close()
print (html[:200])
````

### 代码分析

1. Options

> 设置启动浏览器选项 

[官方文档](https://peter.sh/experiments/chromium-command-line-switches/)

````

chrome_opt = Options()      # 创建参数设置对象.
chrome_opt.add_argument('--headless')   # 无界面化.
chrome_opt.add_argument('--disable-gpu')    # 配合上面的无界面化.
chrome_opt.add_argument('--window-size=1366,768')   # 设置窗口大小, 窗口大小会有影响.
chrome_opt.add_argument('-user-agent=""') #设置请求头的User-Agent
````

| 启动参数 | 作用 |
| -------- | ---- |
|–user-agent=”“|	设置请求头的User-Agent|
|–window-size=长,宽|	设置浏览器分辨率|
|–headless|	无界面运行|
|–start-maximized|	最大化运行|
|–incognito|	隐身模式|
|–disable-javascript|	禁用javascript|
|–disable-infobars|	禁用浏览器正在被自动化程序控制的提示|

2. 获取cookie

````
diccookie=driver.get_cookies()
````

