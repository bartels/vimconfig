" pathogen modifes the runtime path to include plugins under ~/.vim/bundle/
let g:pathogen_disabled = []
if !has('python')
    call add(g:pathogen_disabled, 'ultisnips')
    call add(g:pathogen_disabled, 'jedi')
endif
call pathogen#infect()

" Some nice defaults
set nocompatible
set number  " line numbering
set title   " display title in terminal window
set hidden  " buffers can be hidden without requiring disk write
set incsearch hlsearch  " highlight and show search terms as you type
set scrolloff=3  " min number of lines of context to show while scrolling
set sidescrolloff=3  " same as above but with columns
set wildmenu
set wildmode=longest,list  " sets file completion search to stop at common substring
set wildignore=*~,*.bak,*.o,*.pyc,*.pyo  " ignore these file globs in wildmode
set completeopt=longest,menuone  " insert mode completion menu
set laststatus=2  " always show statusline
set backspace=indent,eol,start	" more powerful backspacing
set autoindent
set fileformats+=mac
set display+=lastline
set history=1000
set tabpagemax=50
" Turn off match paren
let loaded_matchparen = 1

" spaces, not tabs
set tabstop=8
set shiftwidth=4
set shiftround
set softtabstop=4
set expandtab
set smarttab


" Turn on syntax and filetype detection
syntax on
filetype plugin indent on

" Special filetypes
autocmd FileType html set filetype=htmldjango
autocmd BufRead,BufNewFile *.thtml set filetype=php
autocmd BufRead,BufNewFile *.ctp set filetype=php
autocmd BufRead,BufNewFile *.wsgi set filetype=python
autocmd BufRead,BufNewFile  Vagrantfile set filetype=ruby

" Don't write pesky backup files
set nobackup
set nowritebackup

" Use ~/.cache/vim/ for swap files, backups & undo history
" but only if it exists: mkdir -p ~/.cache/vim/{swap,backup,undo}
if isdirectory(expand('~/.cache/vim'))
    if &directory =~# '^\.,' && isdirectory(expand('~/.cache/vim/swap'))
        set directory^=~/.cache/vim/swap//
    endif
    if &backupdir =~# '^\.,' && isdirectory(expand('~/.cache/vim/backup'))
        set backupdir^=~/.cache/vim/backup//
    endif
    if exists('+undodir') && isdirectory(expand('~/.cache/vim/undo')) && &undodir =~# '^\.\%(,\|$\)'
        set undodir^=~/.cache/vim/undo//
        set undofile
    endif
endif

" Color Theme
if has('gui_running')
    let g:solarized_menu=0
    call togglebg#map("<F6>")
    set background=light
    colorscheme solarized
    set guifont=DejaVu\ Sans\ Mono\ 9.6
else
    set t_Co=256
    let g:solarized_termcolors=256
    set background=dark
    colorscheme wombat
endif

" Mouse support
if has("mouse")
    set mouse=a
endif

" Folding
set foldmethod=manual
autocmd FileType text setlocal foldmethod=marker

" Change the mapleader from \ to ,
let mapleader=","

" View for invisible chars when using set list
set listchars=tab:▸\ ,eol:¬
nmap <leader>l :set list!<CR>

" matchit is nice for extended matching using '%'
runtime macros/matchit.vim

" Plugin Settings
"""""""""""""""""

" Syntastic settings
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_auto_jump = 0
let g:syntastic_auto_loc_list = 2
nmap <leader>e :SyntasticToggleMode<CR>

" ultisnips Settings
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsListSnippets = "<s-tab>"
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "snippets"]
let g:UltiSnipsEditSplit = "vertical"

" gundo plugin (only works with vim >= 7.3
if v:version >= 703 && has("python")
    nnoremap <F5> :GundoToggle<CR>
else
    let g:gundo_disable = 1
endif

" ctrlp
nnoremap <leader>f :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>
let g:ctrlp_max_height = 30
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_open_multiple_files = 't'
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("h")': ['<C-x>', '<C-s>'],
    \ 'AcceptSelection("t")': ['<C-t>', '<C-Enter>'],
    \ }


" Custom Mappings
"""""""""""""""""

" Fix so vim can recognize "Alt" key in terminal that send it as an escape
" sequence (gnome-terminal, for example)
if ! has("gui_running")
    let c='a'
    while c <= 'z'
        exec "set <A-".c.">=\e".c
        exec "imap \e".c." <A-".c.">"
        let c = nr2char(1+char2nr(c))
    endw
    set timeout ttimeoutlen=50
endif


if has("gui_running")
    " Get us some familiar keybindings in insert mode
    source $VIMRUNTIME/mswin.vim

    " no ctrl-a in normal mode
    nunmap <C-A>

    " get scrolling back from mswin.vim
    noremap <C-y> <C-y>

    " editing helpers (these only work in gui mode)
    inoremap <C-Enter> <C-o>o
    inoremap <C-S-Enter> <C-o>O
    inoremap <C-DEL> <C-O>dw
    inoremap <C-BACKSPACE> <C-W>
endif


" Escape insert mode
inoremap <Esc> <Esc>`^
imap kj <Esc>

" Escaping command mode (I've been playing with emacs evil-mode)
cnoremap <C-g> <C-c>

" Save file with sudo
cmap w!! w !sudo tee % > /dev/null

" Clear last search
nnoremap <leader><space> :noh<CR>

" navigating windows
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k

" omnicomplete shortcut
inoremap <C-Space> <C-x><C-o>

" tabpanes
nmap <silent> <leader>t :tabnew<CR>
nmap <silent> <leader>w :close<CR>
noremap <A-j> gt
noremap <A-k> gT
if has("gui_running")
    noremap <C-TAB> gt
    noremap <C-S-TAB> gT
    noremap <S-A-J> gt
    noremap <S-A-K> gT
endif

" splits
nmap <silent> <leader>v :vsplit<CR>
nmap <silent> <leader>s :split<CR>

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Quickly edit & source vimrc
nmap <silent> <leader>ev :e $HOME/.vim/vimrc<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
