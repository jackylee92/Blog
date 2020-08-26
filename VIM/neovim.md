## 依赖

````
yum install -y gcc gcc-c++ bison flex glibc-devel ncurses-devel perl perl-Module-Install.noarch git zlib-devel curl-devel autoconf sysstat libffi-devel ranger ctags
````

* Mac 图标

```shell
brew tap homebrew/cask-fonts
brew cask install font-hack-nerd-font
```

* python3

````
yum install python3
````

* dev

````
yum install python-devel
sudo yum install python3-devel
sudo pip3 install neovim-remote
````

* rg

````
sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
sudo yum install -y ripgrep
````

* pip2

````
wget https://bootstrap.pypa.io/get-pip.py
python ./get-pip.py
````

yum install python-neovim

yum install python3-neovim

pip3 install neovim

pip3 install neovim

安装RVM

> 非ROOT用户，安装后在用户家目录下.rvm中可以找到rvm可执行文件

````
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

curl -sSL https://get.rvm.io | bash -s stable
````

查看rudy版本

````
$HOME/.rvm/bin/rvm list known
````

选择一个版本下载Rudy

````
$HOME/.rvm/bin/rvm install 2.7
````

重新安装

````
$HOME/.rvm/bin/rvm reinstall 2.7
````

加入环境变量，替换原来的rudy

````
sudo ln -s /home/parallels/.rvm/src/ruby-2.7.0/ruby /usr/local/bin/
sudo ln -s /home/parallels/.rvm/src/ruby-2.7.0/bin/* /usr/local/bin/
````

这是最好关闭终端重新进入，否则gem可能安装neovim失败

进入后查看版本

````
ruby -v
````

不对就再检查下/usr/local/bin中ruby是否可执行

gem安装neovim

````
gem install neovim
````

安装中可能会提示

````
GemWrappers: Can not wrap missing file: rake
GemWrappers: Can not wrap missing file: ruby_executable_hooks
GemWrappers: Can not wrap missing file: executable-hooks-uninstaller
Successfully installed msgpack-1.3.3
GemWrappers: Can not wrap missing file: rake
GemWrappers: Can not wrap missing file: ruby_executable_hooks
GemWrappers: Can not wrap missing file: executable-hooks-uninstaller
Successfully installed multi_json-1.15.0
GemWrappers: Can not wrap missing file: neovim-ruby-host
GemWrappers: Can not wrap missing file: rake
GemWrappers: Can not wrap missing file: ruby_executable_hooks
GemWrappers: Can not wrap missing file: executable-hooks-uninstaller
GemWrappers: Can not wrap missing file: neovim-ruby-host
````

然后找到``neovim-ruby-host``

在$HOME/.rvm/下 

````
find ./ -name neovim-ruby-host
````

找到后

````
sudo ln -s /home/parallels/.rvm/rubies/ruby-2.7.0/lib/ruby/gems/2.7.0/gems/neovim-0.8.1/exe/neovim-ruby-host /usr/local/bin/
````

nvim

````
wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim-linux64.tar.gz
tar -zxvf nvim-linux64.tar.gz
cp -rf nvim-linux64 /usr/local/nvim
ln -s /usr/local/nvim/bin/nvim /usr/local/bin/nvim
chmod u+x /usr/local/bin/nvim
````

nodejs

````
yum install nodejs
sudo npm install -g neovim
````

异常：

````
## Node.js provider (optional)
  - INFO: Node.js: v6.17.1
  - INFO: Neovim node.js host: /usr/lib/node_modules/neovim/bin/cli.js
  - ERROR: Command error (job=18, exit code 1): `node /usr/lib/node_modules/       neovim/bin/cli.js --version` (in '/home/parallels/.rvm/bin')
    Output: /usr/lib/node_modules/neovim/node_modules/@msgpack/msgpack/dist/         Decoder.js:83    async decodeSingleAsync(stream) {                               ^^^^^^^^^^^^^^^^^SyntaxError: Unexpected identifier    at createScript (vm.      js:56:10)    at Object.runInThisContext (vm.js:97:10)    at Module._compile      (module.js:549:28)    at Object.Module._extensions..js (module.js:586:10)        at Module.load (module.js:494:32)    at tryModuleLoad (module.js:453:12)         at Function.Module._load (module.js:445:3)    at Module.require (module.js:      504:17)    at require (internal/module.js:20:19)    at Object.<anonymous> (/     usr/lib/node_modules/neovim/node_modules/@msgpack/msgpack/dist/decode.js:4:      19)
    Stderr: /usr/lib/node_modules/neovim/node_modules/@msgpack/msgpack/dist/         Decoder.js:83    async decodeSingleAsync(stream) {                               ^^^^^^^^^^^^^^^^^SyntaxError: Unexpected identifier    at createScript (vm.      js:56:10)    at Object.runInThisContext (vm.js:97:10)    at Module._compile      (module.js:549:28)    at Object.Module._extensions..js (module.js:586:10)        at Module.load (module.js:494:32)    at tryModuleLoad (module.js:453:12)         at Function.Module._load (module.js:445:3)    at Module.require (module.js:      504:17)    at require (internal/module.js:20:19)    at Object.<anonymous> (/     usr/lib/node_modules/neovim/node_modules/@msgpack/msgpack/dist/decode.js:4:      19)n
  - ERROR: Failed to run: ['node', '/usr/lib/node_modules/neovim/bin/cli.js', '--  version']
    - ADVICE:
      - Report this issue with the output of: 
      - ['node', '/usr/lib/node_modules/neovim/bin/cli.js', '--version']

[No 
````

升级node =》12.18.3

`````
sudo npm install -g n
# n latest // 最新版
# n stable // 稳定版
`````

sudo vim /etc/profile.d/node.sh

````
export NODE_HOME=/usr/local/n/versions/node/12.18.3/
export PATH=$NODE_HOME/bin:$PATH
````

重启终端

查看版本

````
node -v
````

重新安装依赖

````
sudo npm install -g neovim
````

忽略：checkhealth中

剪切板

````
## Clipboard (optional)
  - WARNING: No clipboard tool found. Clipboard registers (`"+` and `"*`) will     not work.
    - ADVICE:
      - :help clipboard
````

> It's problem of your npm, it uses yarn by default, so use yarn install to install dependencies.

````
## Node.js provider (optional)
  - INFO: Node.js: v12.18.3
  - WARNING: Missing "neovim" npm (or yarn) package.
    - ADVICE:
      - Run in shell: npm install -g neovim
      - Run in shell (if you use yarn): yarn global add neovim
````

Plug

````
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
````

异常，curl不支持https，重装

````
wget https://curl.haxx.se/download/curl-7.72.0.tar.gz
tar zxvf curl-7.72.0.tar.gz
cd curl-7.72.0
.configure --prefix=/usr/local/curl
make
make install
ln -s /usr/local/curl/bin/curl /usr/local/bin/curl
````



````
I want to explore the folder where the current file is.
I want to open defx window like explorer.
I want to open file like vimfiler explorer mode.
I want to disable root marker.
I want to resize defx window dynamically.
I want to update defx status automatically when changing file.
I want to open defx when running :e /some/directory/ like netrw.
I want to open file by double click.
I want to separate defx state by tabs.
````





````
CocInstall coc-phpls
CocInstall coc-go
CocInstall coc-highlight
CocInstall coc-snippets
CocInstall coc-bookmark
CocInstall coc-git
````



````
github.com/kisielk/errcheck
github.com/fatih/motion
github.com/koron/iferr
github.com/jstemmer/gotags
golang.org/x/tools/cmd/goimports
github.com/golangci/golangci-lint/cmd/golangci-lint
````





````
12.代码跳转
:GoDef 跳转到定义的地方
快捷键: ctrl+]或 gd
返回: ctrl+o
大跳: :GoDefPop 直接跳回开始跳转的地方
:GoDefStack 显示你跳转的记录。然后可以直接选择一个进入
:GoDefStack 清除你的跳转记录
````

