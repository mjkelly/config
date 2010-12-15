" ~/.vimrc
" Michael Kelly
" Wed Dec 15 01:56:33 EST 2010

" **********************************************************
" * variables                                              *
" **********************************************************
set nocompatible

set nu
set noerrorbells
set nomodeline
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

" **********************************************************
" * keyboard mappings                                      *
" **********************************************************

colorscheme koehler

source ~/.vim/sparc.vim
source ~/.vim/yanktmp.vim

" for PhpDoc support
source ~/.vim/php-doc.vim
"imap  <esc>:set paste<CR>:exe PhpDoc()<CR>:set nopaste<CR>i
inoremap  <esc>:call PhpDocSingle()<CR>i
nnoremap  :call PhpDocSingle()<CR>
vnoremap  :call PhpDocRange()<CR>

map <C-J> :next<CR>
map <C-K> :previous<CR>

map <C-I> :call InterpretFile()<CR>

map <C-H> :nohls<CR>

let g:yanktmp_file = $HOME . "/.vim/yanktmp"
map <silent> sy :call YanktmpYank()<CR>
map <silent> sp :call YanktmpPaste_p()<CR>
map <silent> sP :call YanktmpPaste_P()<CR>

source ~/.vim/playlist.vim
let g:vimplaylist_file = $HOME . "/vimplaylist.m3u"

map ,s :setlocal spell! spell?<CR>
map ,w !!date -d this-monday "+Week of \%F:"<CR>
map ,d !!date "+\%F:"<CR>
map ,p :setlocal paste! paste?<CR>
map ,n :setlocal nu! nu?<CR>
map ,i :setlocal ignorecase! ignorecase?<CR>
map ,r :setlocal ruler! ruler?<CR>
map ,t :NERDTreeToggle<CR>
map ,u :!urlview %<CR>
map <silent> ,l :call VimPlaylistAdd()<CR>



set viminfo='100,<500,s10,h

syntax on


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
	set ts=8
	set sw=8
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
	" note: this is assumed to be the default output of date(1) (which it always is in my experience),
	" so date formats don't get mixed up
	exec ':silent %s/\$date\$/' . strftime("%a %b %e %H:%M:%S %Z %Y") . '/'
	exec ':silent 0'
endfunction

fun! InterpretFile()
	exec ':!' . g:interpret_cmd . ' ' . expand("%")
endfunction

" **********************************************************
" * more config after functions...                         *
" **********************************************************
"call Use2Spaces()
call Use4Spaces()

if !exists("autocmds")
	let autocmds = 1

	" always jump to the last cursor position
	au BufReadPost *
		\ if line("'\"") > 0 && line ("'\"") <= line("$") |
		\   exe "normal! g'\"" |
		\ endif

	" for InterpretFile
	au BufEnter * let g:interpret_cmd="true"
	au BufEnter *.lsp let g:interpret_cmd="clisp"
	au BufEnter *.pl let g:interpret_cmd="perl"
	au BufEnter *.ml let g:interpret_cmd="ocaml"
	au BufEnter *.py let g:interpret_cmd="python2.4"
	au BufEnter *.rb let g:interpret_cmd="ruby"
	au BufEnter *.php let g:interpret_cmd="php -l"

	au BufEnter *.rhtml set syn=eruby
	au BufEnter *.rhtm set syn=eruby
	au BufEnter *.lsp :call Use4Spaces()
	au BufEnter *.ml :call Use2Spaces()
	au BufEnter *.vimrc :call UseTabs()
	au BufEnter Makefile :call UseTabs()

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
endif

