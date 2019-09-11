set backspace=indent,eol,start
"打开语法高亮
syntax on
"使用配色方案
colorscheme desert
"打开文件类型检测功能
filetype on

"不同文件类型采用不同缩进
"filetype indent on

" autoload .vimrc
"autocmd! bufwritepost $HOME/.vimrc source %

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

"设置搜索高亮配色  :hi查询颜色代码
set nobackup
set hlsearch
set incsearch
set hls
set showmatch

set autoread 

"取消自动备份及产生swp文件
set nobackup
set nowb
set noswapfile

set nu
set cindent


function! UpdateCtags()
	let curdir=getcwd()
	while !filereadable("./tags")
	cd ..
	if getcwd() == "/"
	break
	endif
	endwhile
	if filewritable("./tags")
		!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
	endif
	execute ":cd " . curdir
endfunction
nmap <F5> :call UpdateCtags()<CR>
set tags=~/ink-sanguo-server-new/tags


" set map leader

let mapleader = "\<Space>"

"对搜索的设置 .cpp
map fc :call Search_Word_Cpp()<CR>:copen<CR>
function! Search_Word_Cpp()
let w = expand("<cword>") " 在当前光标位置抓词
execute "vimgrep " . w . " **\*.cpp"
endfunction
"
"对搜索的设置 .h
map fh :call Search_Word_Head()<CR>:copen<CR>
function! Search_Word_Head()
let w = expand("<cword>") " 在当前光标位置抓词
execute "vimgrep " . w . " **\*.h"
endfunction

filetype plugin on
" omni
 set completeopt=menu,menuone  
let OmniCpp_MayCompleteDot=1    "打开  . 操作符
let OmniCpp_MayCompleteArrow=1  "打开 -> 操作符
let OmniCpp_MayCompleteScope=1  "打开 :: 操作符
let OmniCpp_NamespaceSearch=1   "打开命名空间
let OmniCpp_GlobalScopeSearch=1  
let OmniCpp_DefaultNamespace=["std"]  
let OmniCpp_ShowPrototypeInAbbr=1  "打开显示函数原型
let OmniCpp_SelectFirstItem = 2 "自动弹出时自动跳至第一个
highlight Pmenu    guibg=darkgrey  guifg=black
highlight PmenuSel guibg=lightgrey guifg=black

" 设置NerdTree
 map <F3> :NERDTreeMirror<CR>
 map <F3> :NERDTreeToggle<CR>
 autocmd vimenter * NERDTree
" 当vim中没有其他文件，值剩下nerdtree的时候，自动关闭窗口
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let s:ink_sanguo_proj_dir = '/home/liuzj/ink-sanguo-server-new'

function! CompileSpecificProject(proj_path)
    let s:src_path = a:proj_path . "/src"

    exe 'cd' s:src_path
    set makeprg=./INSTALL
    make!
endfunction

function! CompileProject()
    let s:path = expand('%:p')

    let s:found = 0
    let s:proj_names = ['online', 'cache', 'db', 'login', 'proxy', 'switch', 'world', 'log', 'matching', 'battle']

    for proj_name in s:proj_names
        let s:proj_path = s:ink_sanguo_proj_dir . "/" . proj_name
        echo "search ".s:path.", ".s:proj_path

        if s:path =~ s:proj_path
            let s:found = 1
            :call CompileSpecificProject(s:proj_path)
            break
        endif
    endfor

    if s:found == 0
        echo "not in project"
    endif
endfunction

nmap <leader>cc :call CompileProject()<CR>
nmap <leader>cn :cn<CR>
nmap <leader>cp :cp<CR>
nmap <leader>cw :cw<CR>
nmap <leader>cs :ccl<CR>

" #############################################
set laststatus=2  "永远显示状态栏
set t_Co=256      "在windows中用xshell连接打开vim可以显示色彩

"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   
let g:airline#extensions#tabline#enabled = 1
"打开tabline功能,方便查看Buffer和切换，这个功能比较不错"
 "我还省去了minibufexpl插件，因为我习惯在1个Tab下用多个buffer"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

"设置切换Buffer快捷键"
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" 关闭状态显示空白符号计数,这个对我用处不大"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'

" vp doesn't replace paste buffer
xnoremap <expr> p 'pgv"'.v:register.'y'


" 设置NerdTree
 nmap <leader>ff :LeaderfFile<CR>
 nmap <leader>ft :LeaderfTag<CR>
 nmap <leader>fm ::LeaderfMru <CR>
 nmap <leader>fbt :LeaderfBufTag <CR>
 nmap <leader>fba :LeaderfBufTagAll <CR>

hi Search term=reverse ctermbg=Yellow ctermfg=Black guibg=lightYellow guifg=Black

"Conque GDB
""待调试文件位于屏幕上方
let g:ConqueGdb_SrcSplit = 'above'
"保存历史
let g:ConqueGdb_SaveHistory = 1
"修改Conque GDB的Leader键
let g:ConqueGdb_Leader = ','
"总是显示颜色
let g:ConqueTerm_Color = 2 
""程序结束运行时，关闭Conque GDB窗口
let g:ConqueTerm_CloseOnEnd = 1  
"Conque Term配置错误时显示警告信息
let g:ConqueTerm_StartMessages = 0 

:map<F8>:bel 30vsplit gdb-variables<cr>
:run macros/gdb_mappings.vim

"if filereadable(expand("~/.vimrc.bundles"))
"  source ~/.vimrc.bundles
"endif
