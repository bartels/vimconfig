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


" Some Key Bindings
inoremap    <C-l>     <ESC>

" command completion
inoremap    <C-SPACE>        <C-N>

" switch between tabs
nnoremap    <C-TAB>             <C-C>:tabnext<CR>
noremap     <C-TAB>             :tabnext<CR>
inoremap    <C-TAB>             <C-O>:tabnext<CR><ESC>

" open a tab
nnoremap    <C-N>               <C-C>:tabnew<CR>

" close the current buffer
inoremap    <C-W>               <C-O>:bd<CR>

" delete words before/after the cursor
inoremap    <C-DEL>             <C-O>dw
inoremap    <C-BACKSPACE>       <C-LEFT><C-O>dw
