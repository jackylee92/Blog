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
set scrolloff=10
" set noswapfile " 不产生异常关闭的缓存文件
" set backupext=.vimbak " 设置备份文件的后缀名
" silent !mkdir -p ~/.config/nvim/tmp/backup
" silent !mkdir -p ~/.config/nvim/tmp/undo
" silent !mkdir -p ~/.config/nvim/tmp/sessions
" set backupdir=~/.config/nvim/tmp/backup,.
" set directory=~/.config/nvim/tmp/backup,.

set cursorline
set cursorcolumn
" 设置光标所在行和列的颜色
" highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
"
let mapleader=" "
" 括号自动补全
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {<CR>}<ESC>O
nnoremap <silent> cc  $zf%<cr>
inoremap <C-k>  <Up>
inoremap <C-j>  <Down>


call plug#begin()

" defx
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'kristijanhusak/defx-icons'

" vim-go
Plug 'fatih/vim-go'

"  powerline
Plug 'itchyny/lightline.vim',

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
Plug 'morhetz/gruvbox'

" 排版
Plug 'sbdchd/neoformat'

" 图标
Plug 'ryanoasis/vim-devicons'

" 终端
Plug 'voldikss/vim-floaterm'

" fzf
Plug 'junegunn/fzf.vim'

" 彩虹括号
Plug 'luochen1990/rainbow'

" git
Plug 'tpope/vim-fugitive'

call plug#end()

let g:rainbow_active = 1

" 主题配色
colorscheme gruvbox

" 文件列表
call defx#custom#option('_', {
            \ 'winwidth': 30,
            \ 'split': 'vertical',
            \ 'direction': 'topleft',
            \ 'show_ignored_files': 1,
            \ 'buffer_name': '',
            \ 'toggle': 1,
            \ 'resume': 1
            \ })
" call defx#custom#column('icon', {
"             \ 'directory_icon': '▸',
"             \ 'opened_icon': '▾',
"             \ 'root_icon': ' ',
"             \ })

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
    " 退出
    nnoremap <silent><buffer><expr> q defx#do_action('quit')
    " 进入，打开文件夹、文件
    nnoremap <silent><buffer><expr> o <SID>defx_toggle()
    nnoremap <silent><buffer><expr> O <SID>defx_toggle_all()
    nnoremap <silent><buffer><expr> x defx#do_action('close_tree')
endfunction

function! s:defx_toggle() abort
    if defx#is_directory()
        return defx#do_action('open_tree', ['toggle']) " 打开或关闭文件夹，不进入
    endif
    return defx#do_action('multi', [['drop', 'vsplit'], '']) " defx右边打开新buffer，不关闭defx
endfunction

function! s:defx_toggle_all() abort
    if defx#is_directory()
        return defx#do_action('open_tree', ['recursive']) " 递归打开
    endif
    return defx#do_action('multi', ['drop', '']) " 替换先文件打开
endfunction

augroup go
  autocmd!
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

"
" call defx#custom#column('git', 'indicators', {
"   \ 'Modified'  : '✹',
"   \ 'Staged'    : '✚',
"   \ 'Untracked' : '✭',
"   \ 'Renamed'   : '➜',
"   \ 'Unmerged'  : '═',
"   \ 'Ignored'   : '☒',
"   \ 'Deleted'   : '✖',
"   \ 'Unknown'   : '?'
"   \ })
" "call defx#custom#column('git', 'column_length', 1)
" call defx#custom#column('git', 'show_ignored', 0)

let g:coc_global_extensions = [
	\ 'coc-actions',
	\ 'coc-css',
	\ 'coc-diagnostic',
	\ 'coc-explorer',
	\ 'coc-flutter-tools',
	\ 'coc-gitignore',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-lists',
	\ 'coc-prettier',
	\ 'coc-pyright',
	\ 'coc-python',
	\ 'coc-snippets',
	\ 'coc-sourcekit',
	\ 'coc-stylelint',
	\ 'coc-syntax',
	\ 'coc-tasks',
	\ 'coc-todolist',
	\ 'coc-translator',
	\ 'coc-tslint-plugin',
	\ 'coc-tsserver',
	\ 'coc-vimlsp',
	\ 'coc-yaml',
	\ 'coc-highlight',
	\ 'coc-yank']

" line
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

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

" Open :GoDeclsDir with ctrl-g
nnoremap <C-g> :GoDef<cr>
nnoremap <silent> <leader>l  :<C-u>Defx<cr>
nnoremap <silent> <leader>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <leader>f  :<C-u>Leaderf file<cr>
nnoremap <silent> <leader>c  :<C-u>Leaderf rg<cr>
nnoremap <silent> <leader>a  :<C-u>Leaderf function<cr>
nnoremap <silent> <leader>g :<C-u>CocList --normal gstatus<CR>

" 光标所在地行颜色
highlight CursorLine   cterm=NONE ctermbg=black ctermfg=NONE guibg=NONE guifg=NONE


" vim-go 
let g:go_fmt_command = 'goimports'
let g:go_autodetect_gopath = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" leaderf
let g:Lf_PopupPalette = {
    \  'light': {
    \      'Lf_hl_match': {
    \                'gui': 'NONE',
    \                'font': 'NONE',
    \                'guifg': 'NONE',
    \                'guibg': '#303136',
    \                'cterm': 'NONE',
    \                'ctermfg': 'NONE',
    \                'ctermbg': '236'
    \              },
    \      'Lf_hl_cursorline': {
    \                'gui': 'NONE',
    \                'font': 'NONE',
    \                'guifg': 'NONE',
    \                'guibg': '#303136',
    \                'cterm': 'NONE',
    \                'ctermfg': 'NONE',
    \                'ctermbg': '236'
    \              },
    \      }
    \  }
