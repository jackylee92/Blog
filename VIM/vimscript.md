### VimScript

---



```
按键   操作       移动
----   --------   -------------
dw     删除       到下一个单词
ci(    修改       在括号内
yt,    复制       到逗号
g_：移动到当前行的最后一个非空字符上。
$: 移动到当前行的最后一个非空字符上,会选中换行符号
:set wrap 折行显示
```



命令：

:echo 						//输出，不保存在messages中

:ehcom					//输出，保存在messages中

:set number			//设置行号

:set nunumber		//关闭行号

:set number!			//关闭行号

:set number?			//打印当前行号设置

:set numberwidth	//行号那列的宽

:set numberwidth?	//打印行号宽

:set wrap					//设置是否折行显示

:set wrap!					//设置是否折行显示取反

:set wrap?					//显示是否折行的值

// map映射的功能按键，允许递归map按键，非常不建议使用递归；

:map - x						//将-键映射到x键功能

:map - dd					//将-键映射到dd键功能，dd功能是删除一行

:map <c-d> dd		//将ctrl+d组合按键映射到dd功能

:nmap 、 :vmap 、 :imap 	//三种模式下设置映射 map默认是nmap模式；各自模式映射只在各自模式中生效

:nunmap -				//删除-的映射

//nnoremap映射的功能按键，不允许递归map；如果映射了x执行dd,-执行x 则敲-只会输入删除光标所在字符

:nnoremap x dd	//将-键映射到dd键功能，dd功能是删除一行

//leader 前缀，支持敲两个按键实现功能

:let mapleader = "-"		//设置leader为-键

:nnoremap <leader>d dd	//结合上一个，输入-再输入d 映射到dd，实现删除一行

:let maplocalleader = "-"	//设置local leader 为-键

:vsplit								//打开一个纵向分屏

:iabbrev adn and			//insert模式下输入adn后空格、符号，adn会自动转为and

:iabnrev @@ xxx@xxx.com	//insert模式下输入@@ 空格后自动转为xxx@xxx.com

:nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel 	//负责的替换，将单词用""包裹

:nnoremap <buffer> <leader>x dd		//在当前buffer中该映射有效

:setlocal wrap									//设置当前buffer中的折行显示

:setlocal number							//设置当前buffer中的行号

:autocmd BufNewFile * :write	//监听打开一个任意类型的buffer时执行:write保存命令

:autocmd BufNewFile *.txt :w	//监听打开一个.txt结尾文件时执行:w保存命令

:autocmd BufWritePre *.html :normal gg=G	//保存.html结尾文件时 格式话文件内容

:autocmd BufWritePre,BufRead *.html :normal gg=G	//不仅在写html文件的时候进行缩进处理，读html文件的时候也会进行缩进处理

:autocmd FileType javascript nnoremap <brffer> <localleader>c I//<esc>		//.js文件中<localleader>c功能是行首输入// 注释

:autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>			//.py文件中<lcoalleader>c功能是行首输入#注释

:help autocmd-events 			//查看自动命令可绑定的所有事件



//一组自动命令绑定事件，多次执行会合并，出现绑定事件重复，每个组前面加autocmd!先清空这个组中的绑定事件

:augroup testgroup

:autocmd!

:autocmd BufWrite * :echom"haah"

:autocmd BufWrite * :echom"xixi"

:augroup



:omoremap p i(			//Operator-Pending映射，理解为对一个范围操作，如下

:dw								//删除一个单词 d为动作，w为范围，上例中定义了 p为i( 如下

:ci(								//c修改 i( 为括号中 等于下例

:cp								//c修改 i( 为括号中 

https://www.kancloud.cn/kancloud/learn-vimscript-the-hard-way/49300



normal



execut



#### 零

学会盲打

#### 壹

配置文件先从最简开始，在 伍级 前别考虑配置插件，千万别硬背命令，千万别直接取用别人的配置文件
基本还是长时间待在 insert mode 下，会觉得 vim 也不过尔尔，也不好用，

这个时候，编辑效率可能比用原来的一般编辑器还低，别人问使用什麼编辑器时，
多半会回答：vim 再配一个 nano, kate, kwrite, gedit, geany 或其他 IDE 之类的

#### 贰

养成习惯待在 normal mode（normal 不是白叫的），只有输入时才进入 insert mode，输入完马上 <ESC>
学习 normal mode 下的移动命令，这个时候输入文字标准流程：

1. normal mode 移动命令准确定位光标（记住，搜索命令也是移动命令）
2. 进入 insert mode 编辑（进入 insert mode 别只用 i，要习惯视乎情况，使用 I a A o O s C）
3. <ESC> 返回 normal mode

这个时候，编辑效应会恢复到和你之前用的普通编辑器一样，甚至有少量提高

#### 叄

学习什麼是 operator（命令 d y c 等），什麼是 motion（所有能移动光标的命令，h j k l w e f t / ? 等等），
学习 operator + motion 的方式，如 ct. （将当前光标到 . (点) 之间的内容删除并进入 insert mode 准备修改）
学习基础的 Ex 命令，:s 什麼的

这个时候，编辑效率开始明显提高，在用其他一般编辑器时，会开始觉得不习惯和低效率

#### 肆

学习 text-objects，知道 operator + text-objects 的方法，可进行手术般精准的定位和修改，
既然你主要用在 c/c++，举一些在这个情况下有用的例子：

ci" （由 change operator 和 text-object i" 组成）

> 这个命令会找到当前光标所在行的下一个 " 括起来的字符串，清除引号裏面的内容，并进入 insert mode 以方便修改
> 用起来比解释起来简单，你可用 const char* hello = "Hello world."; 类似这样的代码来测试

yaB （由 yank operator 和 text-object aB 组成）

> 这个命令会将当前光标所在的代码块（{} 括起来的内容，包括花括号本身）复制到默认 register，
> 方便在其他地方用 p 贴出来（当然，写代码不鼓励 copy and paste），你可用用任何一个 {} 来测试，然后找另外一个地方 p

gUiw （由 make uppercase operator 和 text-object iw 组成）

> 这个命令会将当前光标所在的 word 全部变成大写
> 如将 max_size 变成 MAX_SIZE

这个时候，开始知道为什麼 vim 精确高效，而且并不是因为全键盘无需鼠标

#### 伍

习惯 operator + motion 后，发现 . 命令很好用，多注意使用可重复的命令组合
练习使用书签定位，q 记录宏，使用多个 register，使用 args，使用 buffer
使用其他的 Ex 命令

这个时候，想不起没用 vim 之前的日子是怎麼过来的

#### 陆

开始 map 经常反覆使用的命令，开始写 vimscript，开始知道自己需要什麼样的插件
试推荐几个：
pathogen 或 vundle，tagbar, CtrlP, Gundo, UltiSnips，surround，Syntastic，Conque，ack.vim，vim-commentary，fugitive（如果是 git 用户）
还有不少，但多对 c/c++ 没直接帮助，就不提了

这个时候，对其他编辑器提不起兴趣，或许 emacs 除外

#### 柒

拥有完全个人化的 vimrc，基本进入化境，成为江湖上的传说
常有旁人观察你编辑后，激起雄心壮志想要学 vim，尝试几个小时候因为觉得热键太不"人性化”而放弃，
但偶尔会向人提起他见过江湖上有你这麼一号人物