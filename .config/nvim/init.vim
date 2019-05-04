execute pathogen#infect()
filetype plugin on

set hlsearch
set modelines=10
set textwidth=79

set termguicolors
set background=light

" toggle between tabs and spaces
function! ChangeIndent()
  if &expandtab
    execute IndentTabs()
    echo "Indent: Tabs, ts =" &ts
  else
    execute IndentSpaces()
    echo "Indent: Spaces, ts =" &ts
  endif
endfunction
function! IndentTabs()
    set sw=4 ts=4 noexpandtab
endfunction
function! IndentSpaces()
    set sw=2 ts=2 expandtab
endfunction
function! Indent4Spaces()
    set sw=4 ts=4 expandtab
endfunction
execute IndentSpaces()

" ============================================================================
" Custom keybindings.
" (Go nuts with stuff hidden behind <Leader> try to keep the rest minimal.)
" ============================================================================
nnoremap <Leader>h :nohlsearch<CR>
nnoremap <Leader>s :setlocal spell! spell?<CR>
nnoremap <Leader>p :setlocal paste! paste?<CR>
nnoremap <Leader>n :setlocal number! number?<CR>
nnoremap <Leader>t :execute ChangeIndent()<CR>
nnoremap <Leader>w :call append(".", strftime("Week %U (%Y-%m-%d)"))<CR>

nnoremap <C-J> :bnext<CR>
nnoremap <C-K> :bprevious<CR>

nnoremap <up> gk
nnoremap k gk
nnoremap <down> gj
nnoremap j gj

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd FileType python nnoremap <leader>f :0,$!yapf<Cr><C-o>

autocmd FileType json nnoremap <leader>f :0,$!python -m json.tool<Cr><C-o>
autocmd FileType json execute Indent4Spaces()

let g:terraform_commentstring='//%s'
let g:terraform_align=1
