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

  