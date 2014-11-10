" ============================================================================
" Thu Apr  3 15:59:37 EDT 2014
" vim configs using pathogen and vim-sensible.
" ============================================================================
execute pathogen#infect()
filetype plugin on

" ============================================================================
" Personlization, beyond vim-sensible.
" (try to keep as minimal as possible)
" ============================================================================
set hlsearch
set number

set ts=2
set sw=2
set expandtab
set modeline

" ============================================================================
" Custom keybindings.
" (Go nuts with stuff hidden behind <Leader> try to keep the rest minimal.)
" ============================================================================
nnoremap <Leader>h :nohlsearch<CR>
nnoremap <Leader>s :setlocal spell! spell?<CR>
nnoremap <Leader>p :setlocal paste! paste?<CR>
nnoremap <Leader>n :setlocal number! number?<CR>

nnoremap <C-J> :bnext<CR>
nnoremap <C-K> :bprevious<CR>

nnoremap <up> gk
nnoremap k gk
nnoremap <down> gj
nnoremap j gj

" ============================================================================
" Stuff to set up context.
" ============================================================================

" always jump to the last cursor position
au BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif

" Go stuff
" TODO: This should be somewhere else. Not sure exactly where.
au BufWritePre *.go silent Fmt
