execute pathogen#infect()
filetype plugin on

set hlsearch
set modelines=10
set textwidth=79

set termguicolors
hi Visual guifg=white guibg=Grey
" if on a light background, set this:
"set background=light

set undofile
set undodir=~/.vimundo

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

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
        \ | exe "normal! g'\"" | endif
endif

function! FormatFile()
    let l:view = winsaveview()
    exe ":0,$!" . g:formatCmd
    call winrestview(l:view)
endfunction

" ============================================================================
" Custom keybindings.
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

" Commentary - use NERDCommenter-like key shortcuts.
xmap <Leader>c <Plug>Commentary
nmap <Leader>c <Plug>Commentary
omap <Leader>c <Plug>Commentary
nmap <Leader>c <Plug>CommentaryLine

" Generic formatting
nnoremap <Leader>f :call FormatFile()<CR>

" Terraform-specific things
let g:terraform_commentstring='//%s'
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" ============================================================================
" Formatting options
" ============================================================================
" autocmd FileType python let g:formatCmd="yapf"
autocmd FileType python let g:formatCmd="yapf3"
autocmd FileType json let g:formatCmd="python -m json.tool"
autocmd FileType json execute Indent4Spaces()
