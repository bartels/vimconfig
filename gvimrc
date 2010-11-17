" Get us some familiar keybindings in insert mode
source $VIMRUNTIME/mswin.vim


" GUI Options
colorscheme desert
set guifont=DejaVu\ Sans\ Mono\ 9.6
" set guifont=Droid\ Sans\ Mono\ 9.6
" set guifont=Inconsolata\ 11.7
win 140 50
set showtabline=1
set guitablabel=%t
set guioptions-=T


" Some Key Bindings we want in gui mode
inoremap <C-l> <ESC>
" close the current buffer
inoremap <C-W> <C-O>:bd<CR>
" delete words before/after the cursor in insert mode
inoremap <C-DEL> <C-O>dw
inoremap <C-BACKSPACE> <C-LEFT><C-O>dw

" tabs
noremap <C-TAB> gt
inoremap <C-TAB> <C-O>gt
