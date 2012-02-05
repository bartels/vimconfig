" Get us some familiar keybindings in insert mode
source $VIMRUNTIME/mswin.vim

" Colors
let g:solarized_menu=0
call togglebg#map("<F6>")
colorscheme solarized

" Fonts
set guifont=DejaVu\ Sans\ Mono\ 9.6

" GUI Options
win 160 60
set showtabline=1
set guitablabel=%t
set guioptions-=T

" Some Key Bindings we want in gui mode
inoremap <C-W> <C-O>:bd<CR>
inoremap <C-DEL> <C-O>dw
inoremap <C-BACKSPACE> <C-LEFT><C-O>dw

" We don't want ctrl-a in normal mode
nunmap <C-A>

" Switching GUI Tabs
noremap <S-A-J> gt
noremap <S-A-K> gT
inoremap <S-A-J> <ESC>gt
inoremap <S-A-K> <ESC>gT
noremap <C-TAB> gt
noremap <C-S-TAB> gT
inoremap <C-TAB> <ESC>gt
inoremap <C-S-TAB> <ESC>gt

" compiz+nvidia sometimes results in the screen not being fully redrawn.
" This mapping allows for a quick screen redraw.
noremap <silent><leader>d :redraw!<CR>

" get scrolling back from mswin.vim
noremap <C-y> <C-y>
