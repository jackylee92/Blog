````
set cursorline
set autoindent
set number
set syntax=on
set iskeyword+=_,$,@,%,#,-
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
set noswapfile " 不产生异常关闭的缓存文件
set backupext=.vimbak " 设置备份文件的后缀名
set backupdir=/local/.vim/bak  " 修改备份文件位置
set undodir=/local/.vim/bak "备份文件保存位置

call plug#begin()

" defx
if has('nvim')
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

"  powerline
Plug 'itchyny/lightline.vim'

" leaderF 搜索
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" 注释
Plug 'preservim/nerdcommenter'

" 代码预设补全
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" 补全
" Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 欢迎界面
Plug 'mhinz/vim-startify'

" 配色
Plug 'rakr/vim-one'

" 搜索优化
Plug 'easymotion/vim-easymotion'

" 排版
Plug 'sbdchd/neoformat'

" 图标
Plug 'kristijanhusak/defx-icons'

" 多光标
Plug 'mg979/vim-visual-multi', {'branch': 'master'}


call plug#end()

" 主题颜色 必须要写在endd后面不然无效
let g:airline_theme='one'
colorscheme one
set background=dark

" 文件列表
call defx#custom#option('_', {
            \ 'winwidth': 30,
            \ 'split': 'vertical',
            \ 'direction': 'topleft',
            \ 'show_ignored_files': 0,
            \ 'buffer_name': '',
            \ 'toggle': 1,
            \ 'resume': 1
            \ })
call defx#custom#column('icon', {
            \ 'directory_icon': '▸',
            \ 'opened_icon': '▾',
            \ 'root_icon': ' ',
            \ })



" autocmd FileType defx call s:defx_mappings()
"
" function! s:defx_mappings() abort
"     nnoremap <silent><buffer><expr> o <SID>defx_toggle_tree()                    " 打开或者关闭文件夹，文件
"     nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')     " 显示隐藏文件
"     nnoremap <silent><buffer><expr> <C-r>  defx#do_action('redraw')
" endfunction
"

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
    " Define mappings
    " 退出
    nnoremap <silent><buffer><expr> q
                \ defx#do_action('quit')

    " 进入，打开文件夹、文件
    nnoremap <silent><buffer><expr> o
                \ <SID>defx_toggle()
    nnoremap <silent><buffer><expr> O
                \ <SID>defx_toggle_all()
                " \ defx#do_action('multi', [['drop', 'split'], 'quit'])

    " 执行shell命令
    nnoremap <silent><buffer><expr> !
                \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> <C-r>
                \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <Space>
                \ defx#do_action('toggle_select') . 'j'
endfunction
function! s:defx_toggle() abort
    " Open current file, or toggle directory expand/collapse
    if defx#is_directory()
        return defx#do_action('open_tree', ['toggle']) " 打开或关闭文件夹，不进入
    endif
    return defx#do_action('multi', [['drop', 'vsplit'], '']) " defx右边打开新buffer，不关闭defx
    " return defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
endfunction
function! s:defx_toggle_all() abort
    " Open current file, or toggle directory expand/collapse
    if defx#is_directory()
        return defx#do_action('open_tree', ['recursive']) " 递归打开
    endif
    return defx#do_action('multi', ['drop', '']) " 替换先文件打开
endfunction
````

