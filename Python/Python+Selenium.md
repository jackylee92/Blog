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

先安装pip， 下面python -m pip install -U ***  针对python3安装模块

````
yum install python-setuptools && easy_install pip
````

安装selenium

````
pip install selenium
// 多个python使用，在当前python版本下/site-packages路径下安装了selenium，这样就可以成功导入selenium了
python -m pip install -U selenium
````

mysql

````
yum -y install libmysqlclient-dev
# python3
python -m pip install -U PyMySQL
# python2 MySQL-python不支持python3 使用PyMySQL代替
python -m pip install -U MySQL-python
python -m pip install -U DBUtils
python -m pip install -U mysql-connector
````

图片code识别

````
conda install -c mcs07 tesserocr
brew install pillow
brew install imagemagick
pip install Pillow
pip install pytesseract
````

滑动验证码识别

```
python -m pip install -U pynput # 控制鼠标扩展
```

一共：

````
python -m pip install -U setuptools
python -m pip install -U mysqlclient
python -m pip install -U PyMySQL
python -m pip install -U selenium
python -m pip install -U mysql-connector
python -m pip install -U pynput # 控制鼠标扩展
````

error 

````
Wrong MySQL configuration: maybe https://bugs.mysql.com/bug.php?id=86971
````

解决方案：https://blog.csdn.net/gaogaorimu/article/details/80903112#commentsedit

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
|–-user-agent=”“|	设置请求头的User-Agent|
|-–window-size=长,宽|	设置浏览器分辨率|
|-–headless|	无界面运行|
|-–start-maximized|	最大化运行|
|-–disable-javascript|	禁用javascript|
|-–disable-infobars|	禁用浏览器正在被自动化程序控制的提示|
|-–user-data-dir=”[PATH]” |指定用户文件夹User Data路径，可以把书签这样的用户数据保存在系统分区以外的分区。|
|-–disk-cache-dir=”[PATH]“ |指定缓存Cache路径|
|-–disk-cache-size= |指定Cache大小，单位Byte|
|-–first run |重置到初始状态，第一次运行|
|-–incognito |隐身模式启动|
|-–disable-javascript |禁用Javascript|
|--omnibox-popup-count="num" |将地址栏弹出的提示菜单数量改为num个。我都改为15个了。|
|--user-agent="xxxxxxxx" |修改HTTP请求头部的Agent字符串，可以通过about:version页面查看修改效果 |
|--disable-plugins |禁止加载所有插件，可以增加速度。可以通过about:plugins页面查看效果 |
|--disable-javascript |禁用JavaScript，如果觉得速度慢在加上这个|
|--disable-java |禁用java |
|--start-maximized |启动就最大化|
|--no-sandbox |取消沙盒模式|
|--single-process| 单进程运行|
|--process-per-tab |每个标签使用单独进程|
|--process-per-site| 每个站点使用单独进程|
|--in-process-plugins |插件不启用单独进程|
|--disable-popup-blocking| 禁用弹出拦截|
|--disable-plugins| 禁用插件|
|--disable-images |禁用图像|
|--incognito| 启动进入隐身模式|
|--enable-udd-profiles |启用账户切换菜单|
|--proxy-pac-url |使用pac代理 [via 1/2]|
|--lang=zh-CN| 设置语言为简体中文|
|--disk-cache-dir| 自定义缓存目录|
|--disk-cache-size| 自定义缓存最大值（单位byte）|
|--media-cache-size| 自定义多媒体缓存最大值（单位byte）|
|--bookmark-menu| 在工具 栏增加一个书签按钮|
|--enable-sync| 启用书签同步|

2. 获取cookie

````
diccookie=driver.get_cookies()
````





问题：

Mac 

1. Idea python配置难搞
2. 需要装mysql相关程序

Linux

1. 编辑器没有
2. 没有chrome





J_NvcCaptchaWrap 蒙层





2700923852----aa123456

2983186539----aaa123456

1142965228----a123456

2961452358----a1234567

2763825141----a123456789





手动：

程序：

相同点：

​	同一个Chrome

​    操作方：（对于浏览器来说都是鼠标）

​		人操作鼠标

​		pytone操作鼠标

​	刷新速度方面个人觉得无差（暂时严重怀疑滑动速度，一顿一顿被识别）

​	第一次失败（python打开滑动验证下载页，手动、程序滑动第一次都是失败）

​	刷新后手动成功、程序一直失败



滑动滑块不能利用webdriver，利用pynput这个模块去做拖动操作，这个库是比较底层的，调用win32。之前使用pyautogui发现不行，估计被封装多次，已经被识别出来了