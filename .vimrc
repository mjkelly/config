" ~/.vimrc
" Michael Kelly
" Sun Jan 23 20:55:48 EST 2011

" **********************************************************
" * variables                                              *
" **********************************************************
set nocompatible
set nu
set noerrorbells
set showmode
set nowrap
set ignorecase
set backspace=indent,eol,start
set fileformats=unix,dos,mac
set exrc
set nojoinspaces
set noruler
set preserveindent
set showmatch
set incsearch
set hlsearch
set autoindent
set nocindent
set smartindent

syntax on

colorscheme koehler

set viminfo='100,<500,s10,h

" **********************************************************
" * keyboard mappings                                      *
" **********************************************************

source ~/.vim/sparc.vim
source ~/.vim/yanktmp.vim

map <C-J> :bnext<CR>
map <C-K> :bprevious<CR>

map <C-H> :nohls<CR>

let g:yanktmp_file = $HOME . "/.vim/yanktmp"

source ~/.vim/playlist.vim
let g:vimplaylist_file = $HOME . "/vimplaylist.m3u"

map ,s :setlocal spell! spell?<CR>
map ,w !!date -d this-monday "+Week of \%F:"<CR>
map ,d !!date "+\%F:"<CR>
map ,p :setlocal paste! paste?<CR>
map ,n :setlocal nu! nu?<CR>
map ,i :setlocal ignorecase! ignorecase?<CR>
map ,r :setlocal ruler! ruler?<CR>
map ,u :!urlview %<CR>
map <silent> ,l :call VimPlaylistAdd()<CR>
"map <silent> ,y :call YanktmpYank()<CR>
"map <silent> ,p :call YanktmpPaste_p()<CR>
"map <silent> ,P :call YanktmpPaste_P()<CR>

" **********************************************************
" * functions                                              *
" **********************************************************

fun! Use2Spaces()
	set ts=2
	set sw=2
	set expandtab
	set softtabstop=2
endfunction

fun! Use4Spaces()
	set ts=4
	set sw=4
	set expandtab
	set softtabstop=4
endfunction

fun! UseTabs()
	set ts=4
	set sw=4
	set noexpandtab
	set softtabstop=0
endfunction

fun! UseTS2Tabs()
	set ts=2
	set sw=2
	set noexpandtab
	set softtabstop=0
endfunction

" include a template of the specified type 
fun! InclTmpl(type)
	exec '0r ~/.vim/tmpl/' . a:type
	call ProcessHeader()
	echo "Loaded " . a:type . " template"
endfunction

" process special header fields in templates
fun! ProcessHeader()
	exec ':silent %s/\$filename\$/' . expand("%:t") . '/'
	exec ':silent %s/\$date\$/' . strftime("%a %b %e %H:%M:%S %Z %Y") . '/'
	exec ':silent 0'
endfunction

call Use2Spaces()
"call Use4Spaces()

" **********************************************************
" * autoloaded stuff                                       *
" **********************************************************

if !exists("autocmds")
	let autocmds = 1

	" always jump to the last cursor position
	au BufReadPost *
		\ if line("'\"") > 0 && line ("'\"") <= line("$") |
		\   exe "normal! g'\"" |
		\ endif

	au BufEnter *.rhtml set syn=eruby
	au BufEnter *.rhtm set syn=eruby
	au BufEnter *.lsp :call Use2Spaces()
	au BufEnter *.ml :call Use2Spaces()
	au BufEnter *.vimrc :call UseTabs()
	au BufEnter Makefile :call UseTabs()
	au BufEnter *.html :call Use2Spaces()
	au BufEnter *.py :call Use2Spaces()
	au BufEnter *.go :call UseTabs()

	au BufEnter *.email source ~/.vimrc.text
	au BufNewFile,BufRead *.txt :source ~/.vimrc.text

	" -------------------------------------------
	" auto-load templates for some filetypes
	" -------------------------------------------
	au BufNewFile *.c	:call InclTmpl('c')
	au BufNewFile *.h	:call InclTmpl('h')
	au BufNewFile *.hpp	:call InclTmpl('hpp')
	au BufNewFile *.sh	:call InclTmpl('sh')
	au BufNewFile *.java	:call InclTmpl('java')
	au BufNewFile *.py	:call InclTmpl('py')
	au BufNewFile *.cc,*.cpp,*.c++,*.cxx :call InclTmpl('cpp')
	au BufNewFile *.pl,*.cgi	:call InclTmpl('pl')

	au BufReadPost *.txt		:syntax off
	au BufReadPost *.txt.gpg	:syntax off

	" boxes(1) configuration. I didn't repeat the hotkey 10 million times, the
	" example author did. :)
	au BufEnter * nmap ,c !!boxes -d pound-cmt<CR>
	au BufEnter * vmap ,c !boxes -d pound-cmt<CR>
	au BufEnter * nmap ,C !!boxes -d pound-cmt -r<CR>
	au BufEnter * vmap ,C !boxes -d pound-cmt -r<CR>
	au BufEnter *.html nmap ,c !!boxes -d html-cmt<CR>
	au BufEnter *.html vmap ,c !boxes -d html-cmt<CR>
	au BufEnter *.html nmap ,C !!boxes -d html-cmt -r<CR>
	au BufEnter *.html vmap ,C !boxes -d html-cmt -r<CR>
	au BufEnter *.[chly],*.[pc]c nmap ,c !!boxes -d c-cmt<CR>
	au BufEnter *.[chly],*.[pc]c vmap ,c !boxes -d c-cmt<CR>
	au BufEnter *.[chly],*.[pc]c nmap ,C !!boxes -d c-cmt -r<CR>
	au BufEnter *.[chly],*.[pc]c vmap ,C !boxes -d c-cmt -r<CR>
	au BufEnter *.C,*.cpp,*.java nmap ,c !!boxes -d java-cmt<CR>
	au BufEnter *.C,*.cpp,*.java vmap ,c !boxes -d java-cmt<CR>
	au BufEnter *.C,*.cpp,*.java nmap ,C !!boxes -d java-cmt -r<CR>
	au BufEnter *.C,*.cpp,*.java vmap ,C !boxes -d java-cmt -r<CR>
	au BufEnter .vimrc*,.exrc nmap ,c !!boxes -d vim-cmt<CR>
	au BufEnter .vimrc*,.exrc vmap ,c !boxes -d vim-cmt<CR>
	au BufEnter .vimrc*,.exrc nmap ,C !!boxes -d vim-cmt -r<CR>
	au BufEnter .vimrc*,.exrc vmap ,C !boxes -d vim-cmt -r<CR>
	au BufEnter *.lua nmap ,c !!boxes -d ada-cmt<CR>
	au BufEnter *.lua vmap ,c !boxes -d ada-cmt<CR>
	au BufEnter *.lua nmap ,C !!boxes -d ada-cmt -r<CR>
	au BufEnter *.lua vmap ,C !boxes -d ada-cmt -r<CR>
	au BufEnter *.go nmap ,c !!boxes -d c-cmt<CR>
	au BufEnter *.go vmap ,c !boxes -d c-cmt<CR>
	au BufEnter *.go nmap ,C !!boxes -d c-cmt -r<CR>
	au BufEnter *.go vmap ,C !boxes -d c-cmt -r<CR>
	au BufEnter *.hs nmap ,c !!boxes -d ada-cmt<CR>
	au BufEnter *.hs vmap ,c !boxes -d ada-cmt<CR>
	au BufEnter *.hs nmap ,C !!boxes -d ada-cmt -r<CR>
	au BufEnter *.hs vmap ,C !boxes -d ada-cmt -r<CR>
endif

