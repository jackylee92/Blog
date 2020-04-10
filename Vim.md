# Vim
---
## 安装

* 下载最新VIM

````
git clone https://github.com/vim/vim
````

* 安装python

````
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
./configure //或者稳定版 ./configure --enable-optimizations
make
make install
yum install python-devel
````

* 编译安装

> 注意python的config目录 通过``whereis python`` 去每个目录下找下

````
./configure --with-features=huge --enable-pythoninterp --with-python-config-dir=/usr/lib64/python2.7/config/ --enable-python3interp --with-python3-config-dir=/usr/local/lib/python3.7/config-3.7m-x86_64-linux-gnu/ --enable-luainterp --enable-multibyte --enable-fontset

./configure --with-features=huge --enable-pythoninterp --with-python-config-dir=/usr/lib64/python2.7/config/ --enable-luainterp --enable-multibyte --enable-fontset --prefix=/usr/local/vim


make 
make install
````

* configure

````
 ./configure  
–with-features=huge：支持最大特性
–enable-rubyinterp：打开对ruby编写的插件的支持
–enable-pythoninterp：打开对python编写的插件的支持
–enable-python3interp：打开对python3编写的插件的支持
–enable-luainterp：打开对lua编写的插件的支持
–enable-perlinterp：打开对perl编写的插件的支持
–enable-multibyte：打开多字节支持，可以在Vim中输入中文
–enable-cscope：打开对cscope的支持
–with-python-config-dir=/usr/lib64/python2.7/config 指定python 路径
–with-python3-config-dir=/usr/local/python3/lib/python3.6/config-3.6m-x86_64-linux-gnu/ 指定python3路径
–prefix=/usr/local/vim：指定将要安装到的路径(自行创建)
````



## 个人配置

````
" set the runtime path to include Vundle and initialize
set rtp+=/Applications/MacVim.app/Contents/Resources/vim/bundle/vundle/ "我这是macvim 我试了我这边写绝对路径就没有问题；这个就是runtimepath 的缩写
call vundle#begin()

" let Vundle manage Vundle, required  这下面三个就是插件啦。其实在github 中你如果找到其他插件，安装下面格式加在下面即可
Plugin 'gmarik/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'
Plugin 'msanders/snipmate.vim'
Plugin 'Lokaltog/vim-powerline'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/ctrlp.vim'
Plugin 'taglist.vim'
Plugin 'SirVer/ultisnips'
Plugin 'klen/python-mode'
Plugin 'scrooloose/syntastic'


"例如：Plugin 'xxx/xxx'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
nmap <F1> :NERDTreeToggle<cr>　　"这个就是配置nerdtree的使用  就是按f5就出来了

colorscheme molokai
set cursorline
set autoindent
set number
set ignorecase
set lines=50 columns=200
set transparency=4
set syntax=on
set iskeyword+=_,$,@,%,#,-
set guifont=Source_Code_Pro:h12 " 设置字体为  字体：大小

set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

set shortmess=atI

set ruler

set rtp+=/Users/jacky/.vim/bundle/powerline/powerline/bindings/vim/
set laststatus=2
set t_Co=256


"-- Taglist setting --
let Tlist_Process_File_Always=1 "实时更新tags

let Tlist_Inc_Winwidth=0

"不同时显示多个文件的tag，仅显示一个
let Tlist_Show_One_File = 1

"taglist为最后一个窗口时，退出vim
let Tlist_Exit_OnlyWindow = 1

"taglist窗口显示在右侧，缺省为左侧
let Tlist_Use_Right_Window =1

"设置taglist窗口大小
"let Tlist_WinHeight = 100
let Tlist_WinWidth = 40

"设置taglist打开关闭的快捷键F8
noremap <F2> :TlistToggle<CR>

"更新ctags标签文件快捷键设置
noremap <F0> :!ctags -R<CR>

let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏


"syntastic
"设置error和warning的标志
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='►'
"总是打开Location List（相当于QuickFix）窗口，如果你发现syntastic因为与其他插件冲突而经常崩溃，将下面选项置0
let g:syntastic_always_populate_loc_list = 1
"自动打开Locaton List，默认值为2，表示发现错误时不自动打开，当修正以后没有再发现错误时自动关闭，置1表示自动打开自动关闭，0表示关闭自动打开和自动关闭，3表示自动打开，但不自动关闭
let g:syntastic_auto_loc_list = 1
"修改Locaton List窗口高度
let g:syntastic_loc_list_height = 5
"打开文件时自动进行检查
let g:syntastic_check_on_open = 1
"自动跳转到发现的第一个错误或警告处
let g:syntastic_auto_jump = 1
"进行实时检查，如果觉得卡顿，将下面的选项置为1
let g:syntastic_check_on_wq = 0
"高亮错误
let g:syntastic_enable_highlighting=1                                                                                                                                                                                                                                                     
~                                                                                                                                                                                                                                                                                         

````

> 20190726

````
if v:progname =~? "evim"
  finish
endif

source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup          " do not keep a backup file, use versions instead
else
  set backup            " keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile        " keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  set hlsearch
endif

if has("autocmd")

  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent                " always set autoindenting on

endif " has("autocmd")

if has('syntax') && has('eval')
  packadd! matchit
endif


set rtp+=/usr/local/vim/share/vim/vim81/bundle/vundle
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'fatih/vim-go'   " go相关插件
Plugin 'scrooloose/nerdtree'    " 目录插件
Plugin 'Valloric/YouCompleteMe' " 代码提示插件
Plugin 'msanders/snipmate.vim'  " 自动完成 补全代码块
Plugin 'SirVer/ultisnips'   " 自动完成 补全代码块 配合snipmate使用
Plugin 'Lokaltog/vim-powerline' " 颜色
"Plugin 'scrooloose/nerdcommenter' "注释插件
"Plugin 'kien/ctrlp.vim' " 搜索工具
Plugin 'junegunn/fzf' " 搜索工具 适用vim8

"Plugin 'taglist.vim' "使用majutsushi/tagbar代替
"
Plugin 'klen/python-mode'   " python 插件
Plugin 'scrooloose/syntastic'   " 语法检查插件
Plugin 'skywind3000/asyncrun.vim' " 异步执行shell AsyncRun

call vundle#end()

filetype plugin indent on

colorscheme molokai
set cursorline
set autoindent
set number
set syntax=on
set iskeyword+=_,$,@,%,#,-
set guifont=Source_Code_Pro:h12 "
set ignorecase
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set shortmess=atI
set ruler
set laststatus=2
set t_Co=256
" :copen 15 " shell命令结果窗口
" :!ctags -R

let Tlist_Process_File_Always=1 "
let Tlist_Inc_Winwidth=0
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window =1
let Tlist_File_Fold_Auto_Close=1

let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='►'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 1
let g:syntastic_auto_jump = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_highlighting=1
let g:ycm_autoclose_preview_window_after_insertion = 1 " 代码详细提示窗口 自动关闭
autocmd VimEnter * NERDTree " 目录自动打开
" 设置在下面几种格式的文件上屏蔽ycm
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
      \}

" go
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
let g:tagbar_width = 30 "设置tagbar的宽度为30列，默认40
let g:tagbar_autofocus = 1 "这是tagbar一打开，光标即在tagbar页面内，默认在vim打开的文件内
let g:tagbar_sort = 0 "设置标签不排序，默认排序
let g:tagbar_ctags_bin = 'ctags' "tagbar依赖ctags插件

"快捷键自定义
"目录
nnoremap <F1> :NERDTreeToggle<cr>
"函数列表
"noremap <F2> :TlistToggle<CR>
nnoremap <F2> :TagbarToggle<CR>
"文件搜索
nnoremap <f3> :FZF<CR>
"文件搜索 buffer中搜
"nnoremap <f4> :Buffers<CR>
"shell命令结果窗口
nnoremap <f4> :copen 15<CR>
" :copen 15 " shell命令结果窗口

"生成方法跳转tags
noremap <F10> :!ctags -R<CR>

"自动完成 无效 直接修改 /root/.vim/bundle/snipmate.vim/after/plugin/snipMate.vim
"imap <F5> <Plug>snipMateNextOrTrigger
"smap <F5> <Plug>snipMateNextOrTrigger
"
" go的代码提示
" imap <F6> <C-x><C-o>
./install.py --gocode-completer
````



## nerdtree

````
?: 快速帮助文档 

o: 打开一个目录或者打开文件,创建的是 buffer,也可以用来打开书签 

go: 打开一个文件,但是光标仍然留在 NERDTree,创建的是 buffer 

t: 打开一个文件,创建的是Tab,对书签同样生效 

T: 打开一个文件,但是光标仍然留在 NERDTree,创建的是 Tab,对书签同样生效 

i: 水平分割创建文件的窗口,创建的是 buffer 

gi: 水平分割创建文件的窗口,但是光标仍然留在 NERDTree 

s: 垂直分割创建文件的窗口,创建的是 buffer 

gs: 和 gi,go 类似 

x: 收起当前打开的目录 

X: 收起所有打开的目录 

e: 以文件管理的方式打开选中的目录 

D: 删除书签 

P: 大写,跳转到当前根路径 

p: 小写,跳转到光标所在的上一级路径 

K: 跳转到第一个子路径 

J: 跳转到最后一个子路径 

<C-j> 和 <C-k>: 在同级目录和文件间移动,忽略子目录和子文件 

C: 将根路径设置为光标所在的目录 

u: 设置上级目录为根路径 

U: 设置上级目录为跟路径,但是维持原来目录打开的状态 

r: 刷新光标所在的目录 

R: 刷新当前根路径 

I: 显示或者不显示隐藏文件 

f: 打开和关闭文件过滤器 

q: 关闭 NERDTree 

A: 全屏显示 NERDTree,或者关闭全屏 
````



## snipmate 定制

* 修改触发键
> vim /Users/jacky/.vim/bundle/snipmate.vim/after/plugin/snipMate.vim

![snipmate](https://github.com/jackylee92/Blog/blob/master/Images/vim_snipMate.png?raw=true)


* 注释
````
snippet ////
    /*  
     * @Content : ${1}
     * @Param   : ${2}
     * @Return  : array(
     *                  'status' => true/false,
     *                  'msg'    => string,
     *                  'data'   => array()
     *              )   
     * @Author  : lijundong
     * @Time    : `system("date +%Y-%m-%d")`
     */  
````

## PowerLine
> 先按转PowerLine,配置如下

````
set rtp+=/Users/jacky/.vim/bundle/powerline/powerline/bindings/vim/
set laststatus=2
set t_Co=256           
````

## nerdcommenter

````
<leader>cc   加注释
<leader>cu   解开注释

<leader>c<space>  加上/解开注释, 智能判断
<leader>cy   先复制, 再注解(p可以进行黏贴)
````

## ctrlp.vim
> ctrl+p 打开搜索模式

````
<c-t> 在新的tab中打开 
<c-v> 在竖直视图中打开
<c-h> 在水平视图中打开
````

## TagList
````
 <CR>          跳到光标下tag所定义的位置，用鼠标双击此tag功能也一样（但要在vimrc文件中打开此项功能）
o                 在一个新打开的窗口中显示光标下tag
<Space>      显示光标下tag的原型定义
u             更新taglist窗口中的tag
s             更改排序方式，在按名字排序和按出现顺序排序间切换
x             taglist窗口放大和缩小，方便查看较长的tag
+             打开一个折叠，同zo
-             将tag折叠起来，同zc
*             打开所有的折叠，同zR
=            将所有tag折叠起来，同zM
[[            跳到前一个文件
]]            跳到后一个文件
q            关闭taglist窗口
<F1>      显示帮助
````
##YouCompleteMe

* vim vimrc 

  ````
  Plugin 'Valloric/YouCompleteMe'
  ````

* vim

  ````
  PluginInstall
  ````

* 安装（参考README.md文件）

  ````
  cd /Users/jacky/.vim/bundle/YouCompleteMe
  ./install.sh
  ````


##  FZF

````
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf/
apk add bash
./install
````

### 使用

命令模式输入 :CtrlP触发搜索

ctrl+j/h 上下选择搜索框的文件

o 打开文件

* <f5> 更新目录缓存。

* <ctrl+f> / <ctrl+b>  f(forward)，b指backward，切换成前一个或后一个搜索模式

* <ctrl+d> 在”完整路径匹配“ 和 ”文件名匹配“ 之间切换

* <ctrl+r> 在“字符串模式” 和 “正则表达式模式” 之间切换

* <ctrl+j> / <ctrl+k> 上下移动光标

* <ctrl+t> 在新的 tab 打开文件

* <ctrl+v> 垂直分割窗口打开文件

* <ctrl+x> 水平分割窗口打开

* <ctrl+p>, <ctrl+n> 选择历史记录

* <ctrl+y> 文件不存在时创建文件及目录

* <ctrl+z> 标记/取消标记， 标记多个文件后可以使用 <ctrl+o> 同时打开多个文件

删除首尾空格

````
:%s/^\s\+

:%s/\s\+$
````

## 快捷键【折叠】

- zf -- 创建折叠的命令，可以在一个可视区域上使用该命令；先输入zf的位置是折叠开始位置，然后下次光标跳到的位置就是结束位置
- zd -- 删除当前行的折叠；
- zD -- 删除当前行的折叠；
- za -- 打开/关闭当前折叠；
- zR (zO) -- 打开所有折行；
- zM (zC) -- 收起所有折行；
- zM (zC) -- 收起所有折行；
- zk -- 跳到上一个折叠处；
- zj -- 跳到下一个折叠处；
- zo -- 打开折叠的文本；
- zc -- 收起折叠；
- zr -- 打开嵌套的折行；
- zm -- 收起嵌套的折行；
- zi -- enable/disable fold;



## 云VIM (docker_vim)

> 当我通过dockerFile构建了完整的镜像后，发现共有1.2G，
>
> 在该镜像中 系统5M+vim30M+YMC250M+其他插件150M+系统依赖的一些程序100M+golang30M+支持go的包500M+零碎东西 = 1.2G
>
> 太大所以放弃了

### 安装docker

````
yum install docker -y
````

### 下载docker_vim (目前最新版本。比较大，优化空间很大)

````
sudo docker pull registry.cn-hangzhou.aliyuncs.com/lijundong/docker_vim:v2.7
````

### 设置快速启动

````
vim /usr/local/bin/op
·····内容如下·····
#!/bin/bash
set -e
work_pace=`readlink -f $1`
if [ ! -d "${work_pace}" ];then
    echo "请指定需要打开的项目目录！"
    exit 0
fi
echo "正在打开目录:"${work_pace}
docker run -it -w /home -v ${work_pace}:/home registry.cn-hangzhou.aliyuncs.com/lijundong/docker_vim:v2.7 sh -c /bin/op
chmod u+x /usr/local/bin/op
````

### 使用

进入项目跟目录 执行 ``op .`` 即可打开 

### DockerFile

```
FROM docker.io/golang:alpine
MAINTAINER Rethink 
RUN apk update && apk upgrade && apk add --no-cache bash && /bin/bash
ADD molokai.vim /tmp
ADD vimrc /tmp
ADD install.sh /root
RUN chmod u+x /root/install.sh
RUN /root/install.sh
```

### Install.sh

```
#!/bin/bash
apk add --no-cache build-base ctags git libx11-dev libxpm-dev libxt-dev make ncurses-dev python python-dev cmake musl-dev
go version
go get -u golang.org/x/tools/cmd/goimports
go get -u github.com/zmb3/gogetdoc
rm -rf /var/cache/apk/*
git clone https://github.com/vim/vim
cd vim/
./configure --disable-gui --disable-netbeans --enable-multibyte --enable-pythoninterp --prefix /usr --with-features=big --with-python-config-dir=/usr/lib/python2.7/config
make && make install
mkdir -p /usr/share/vim/vim81/bundle/vundle
git clone https://github.com/gmarik/vundle.git /usr/share/vim/vim81/bundle/vundle/
cp /tmp/molokai.vim /usr/share/vim/vim81/colors/molokai.vim
cp /tmp/vimrc /usr/share/vim/vimrc
vim -c PluginInstall -c q -c q
~/.vim/bundle/YouCompleteMe/install.py
rm -rf /vim
rm -rf /root/.vim/bundle/YouCompleteMe/doc
```



