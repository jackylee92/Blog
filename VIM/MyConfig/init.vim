
" __  ____   __  _   ___     _____ __  __ ____   ____
"|  \/  \ \ / / | \ | \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /  |  \| |\ \ / / | || |\/| | |_) | |
"| |  | | | |   | |\  | \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|   |_| \_|  \_/  |___|_|  |_|_| \_\\____|
"
" Author: @LiJunDong

" ===
" === Start Basic Mappings
" ===
let mapleader=" "
let g:USER="LiJunDong"
set hidden
set autoindent
set number
set relativenumber
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
set scrolloff=10
set updatetime=100
set noswapfile " 不产生异常关闭的缓存文件
set backupext=.vimbak " 设置备份文件的后缀名
silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=~/.config/nvim/tmp/undo,.
endif
" <= 右侧行号是否使用一列
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

set cursorline
set cursorcolumn
" 设置光标所在行和列的颜色
" highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
"

" ===
" === End Basic Mappings
" ===

" =====================================华丽的分割线=====================================

" ===
" === Start Plug Install
" ===
call plug#begin()

" vim-go
Plug 'fatih/vim-go'

" powerline
Plug 'itchyny/lightline.vim'
" Plug 'vim-airline/vim-airline'

" 代码片段
Plug 'honza/vim-snippets'

" 注释
Plug 'preservim/nerdcommenter'

" 补全
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 欢迎界面
Plug 'mhinz/vim-startify'

" 配色
Plug 'morhetz/gruvbox'

" 排版
Plug 'sbdchd/neoformat'

" 彩虹括号
Plug 'luochen1990/rainbow'

" 高亮
Plug 'lfv89/vim-interestingwords'

" git
Plug 'tpope/vim-fugitive'

" term
Plug 'voldikss/vim-floaterm'
" ===
" === End Plug Install
" ===

" ===============================华丽的分割线===============================

" ===
" === Start Plug Setting
" ===

call plug#end()

" 主题配色
colorscheme gruvbox
" 光标所在地行颜色
" highlight CursorLine cterm=NONE ctermbg=black ctermfg=NONE guibg=NONE guifg=NONE

" 彩虹括号
let g:rainbow_active = 1

" coc-extension
let g:coc_global_extensions = [
	\ 'coc-actions',
	\ 'coc-css',
	\ 'coc-diagnostic',
	\ 'coc-explorer',
	\ 'coc-flutter-tools',
	\ 'coc-gitignore',
	\ 'coc-git',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-lists',
	\ 'coc-prettier',
	\ 'coc-pyright',
	\ 'coc-python',
	\ 'coc-snippets',
	\ 'coc-sourcekit',
    \ 'coc-syntax',
	\ 'coc-tasks',
	\ 'coc-todolist',
	\ 'coc-translator',
	\ 'coc-tslint-plugin',
	\ 'coc-tsserver',
	\ 'coc-vimlsp',
	\ 'coc-yaml',
	\ 'coc-highlight',
	\ 'coc-floaterm',
	\ 'coc-go',
	\ 'coc-phpls',
	\ 'coc-yank']
"	\ 'coc-stylelint',
"
let g:interestingWordsGUIColors = ['#FFB3FF', '#A4E57E', '#FFDB72', '#FF7272', '#8CCBEA', '#9999FF']

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

augroup go
  autocmd!
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

" line
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'gitbranch', 'modified' ]
      \           ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" 注释
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

" vim-go 
let g:go_fmt_command = 'goimports'
let g:go_autodetect_gopath = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" ===
" === End Plug Setting
" ===
highlight CursorLine cterm=NONE ctermbg=black ctermfg=NONE guibg=NONE guifg=NONE


" mapList
"<leader> 表示静默执行
nnoremap <leader>l :CocCommand explorer<CR>
nnoremap <leader>s :<C-u>CocList -I symbols<cr>
nnoremap <leader>f :<C-u>CocList files<cr>
nnoremap <leader>c :<C-u>CocList grep<cr>
" 高亮相同单词
nnoremap <leader>hh :call InterestingWords('n')<cr>
nnoremap <leader>hh :call UncolorAllWords()<cr>
nnoremap <leader>n :call WordNavigation(1)<cr>
nnoremap <leader>N :call WordNavigation(0)<cr>
" 调出补全
inoremap <expr> <c-space> coc#refresh()
" 查看代码错误
nmap <leader>[ <Plug>(coc-diagnostic-prev)
nmap <leader>] <Plug>(coc-diagnostic-next)
" 代码追踪
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
" 代码格式化
xmap = <Plug>(coc-format-selected)
nmap = <Plug>(coc-format-selected)
" 显示文档
nnoremap <leader>if :call <SID>show_documentation()<CR>
" 回车选择补全后不换行
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

inoremap <C-k>  <Up>
inoremap <C-j>  <Down>
noremap <leader>rc :e ~/.config/nvim/init.vim<CR>
noremap <leader>sc :source ~/.config/nvim/init.vim<CR>
" 折叠
nnoremap <silent> cc  $zf%<cr>
" term
nnoremap <silent> term  :FloatermNew<cr>
