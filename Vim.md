# Vim
---
#### 个人配置
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
set lines=70 columns=200
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
````

#### snipmate 定制

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