" playlist.vim - Write lines to a playlist. Based on yanktmp.vim by
" secondlife <hotchpotch@NOSPAM@gmail.com>.
" Author: Michael Kelly <michael@NO@SPAM@michaelkelly.org>
" Last Change:  2009 May 31 
" Version: 0.1, for Vim 7.1

" DESCRIPTION:
"  This plugin enables vim to grab lines from a file and put them in a
"  'playlist' file.
"
" ==================== file yanktmp.vimrc ====================
" map <silent> sl :call VimPlaylistAdd()<CR>
" ==================== end: yanktmp.vimrc ====================

if v:version < 700 || (exists('g:loaded_vimplaylist') && g:loaded_vimplaylist || &cp)
  finish
endif
let g:loaded_vimplaylist = 1

if !exists('g:vimplaylist_file')
  let g:vimplaylist_file = '/tmp/vimplaylist'
endif

function! VimPlaylistAdd() range
  call writefile( readfile(g:vimplaylist_file, "b") + getline(a:firstline, a:lastline), g:vimplaylist_file, 'b')
endfunction

