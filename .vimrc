" ~/.vimrc
" Michael Kelly
" Wed Jul 10 02:02:19 EDT 2013

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

map <C-J> :bnext<CR>
map <C-K> :bprevious<CR>

map <C-H> :nohls<CR>

map ,s :setlocal spell! spell?<CR>
map ,w !!date -d this-monday "+Week of \%F:"<CR>
map ,d !!date "+\%F:"<CR>
map ,p :setlocal paste! paste?<CR>
map ,n :setlocal nu! nu?<CR>
map ,i :setlocal ignorecase! ignorecase?<CR>
map ,r :setlocal ruler! ruler?<CR>
map ,u :!urlview %<CR>

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

" Comment and uncomment single lines and ranges of text.
fun! Comment()
  exec ":.!boxes -d " . g:boxes_comment_type
endfunction

fun! Uncomment()
  exec ":.!boxes -r -d " . g:boxes_comment_type
endfunction

fun! CommentRange() range
  exec ":'<,'>!boxes -d " . g:boxes_comment_type
endfunction

fun! UncommentRange() range
  exec ":'<,'>!boxes -r -d " . g:boxes_comment_type
endfunction


call Use2Spaces()

" **********************************************************
" Auto-commands, which load when creating/entering/leaving *
" buffers.                                                 *
" **********************************************************
if !exists("autocmds")
  let autocmds = 1

  " always jump to the last cursor position
  au BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif

  " Different filetypes use different kinds of indentation.
  au BufEnter *.lsp :call Use2Spaces()
  au BufEnter *.ml :call Use2Spaces()
  au BufEnter Makefile :call UseTabs()
  au BufEnter *.html :call Use2Spaces()
  au BufEnter *.py :call Use2Spaces()
  au BufEnter *.go :call UseTabs()

  au BufEnter *.email source ~/.vimrc.text
  au BufNewFile,BufRead *.txt :source ~/.vimrc.text

  " auto-load templates for some filetypes
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

  " Configure boxes(1) shortcuts..
  au BufEnter *                let g:boxes_comment_type = 'pound-cmt'
  au BufEnter *.html           let g:boxes_comment_type = 'html-cmt'
  au BufEnter *.[chly],*.[pc]c let g:boxes_comment_type = 'c-cmt'
  au BufEnter *.C,*.cpp,*.java let g:boxes_comment_type = 'java-cmt'
  au BufEnter .vimrc*,.exrc    let g:boxes_comment_type = 'vim-cmt'
  au BufEnter *.lua            let g:boxes_comment_type = 'ada-cmt'
  au BufEnter *.go             let g:boxes_comment_type = 'c-cmt'
  au BufEnter *.hs             let g:boxes_comment_type = 'ada-cmt'

  nmap ,c :call Comment()<CR>
  vmap ,c :call CommentRange()<CR>
  nmap ,C :call Uncomment()<CR>
  vmap ,C :call UncommentRange()<CR>
endif
