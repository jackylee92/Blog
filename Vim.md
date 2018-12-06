# Vim
---
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

\* <f5> 更新目录缓存。



\* <ctrl+f> / <ctrl+b>  f(forward)，b指backward，切换成前一个或后一个搜索模式



\* <ctrl+d> 在”完整路径匹配“ 和 ”文件名匹配“ 之间切换



\* <ctrl+r> 在“字符串模式” 和 “正则表达式模式” 之间切换



\* <ctrl+j> / <ctrl+k> 上下移动光标



\* <ctrl+t> 在新的 tab 打开文件



\* <ctrl+v> 垂直分割窗口打开文件



\* <ctrl+x> 水平分割窗口打开



\* <ctrl+p>, <ctrl+n> 选择历史记录



\* <ctrl+y> 文件不存在时创建文件及目录



\* <ctrl+z> 标记/取消标记， 标记多个文件后可以使用 <ctrl+o> 同时打开多个文件



删除首尾空格

````
:%s/^\s\+

:%s/\s\+$
````

## 快捷键【折叠】

- zf -- 创建折叠的命令，可以在一个可视区域上使用该命令；
- zd -- 删除当前行的折叠；
- zD -- 删除当前行的折叠；
- zfap -- 折叠光标所在的段；
- zo -- 打开折叠的文本；
- zc -- 收起折叠；
- za -- 打开/关闭当前折叠；
- zr -- 打开嵌套的折行；
- zm -- 收起嵌套的折行；
- zR (zO) -- 打开所有折行；
- zM (zC) -- 收起所有折行；
- zj -- 跳到下一个折叠处；
- zk -- 跳到上一个折叠处；
- zi -- enable/disable fold;



## 云VIM (docker_vim)

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

