" pathogen modifes the runtime path to include plugins under ~/.vim/bundle/
let g:pathogen_disabled = []
if !has('python')
    call add(g:pathogen_disabled, 'ultisnips')
    call add(g:pathogen_disabled, 'gundo')
    call add(g:pathogen_disabled, 'jedi')
endif
if !has('lua')
    call add(g:pathogen_disabled, 'neocomplete')
endif
call pathogen#infect()

" Some nice defaults
set nocompatible
set number
set title   " title in terminal window
set hidden  " buffers can be hidden without requiring disk write
set incsearch hlsearch
set scrolloff=3  "context lines while scrolling
set sidescrolloff=3  " same but with columns
set wildmenu
set wildmode=longest,list  " complete to common string, list all matches
set wildignore=*~,*.bak,*.o,*.pyc,*.pyo
set completeopt=menuone,longest,preview
set laststatus=2  " always show statusline
set backspace=indent,eol,start	" more powerful backspacing
set autoindent
set fileformats+=mac
set display+=lastline
set history=1000
set tabpagemax=50
set timeout
set timeoutlen=250 ttimeoutlen=50

let loaded_matchparen = 1 " Turns off matchparen

" spaces, not tabs
set tabstop=8
set shiftwidth=4
set shiftround
set softtabstop=4
set expandtab
set smarttab

" clipboard integration
if has("unnamedplus")
    set clipboard=unnamedplus
endif

" Turn on syntax and filetype detection
syntax on
filetype plugin indent on

" Special filetypes
augroup filetypedetect
  au BufNewFile,BufRead *.thtml,*.ctp set filetype=php
  au BufNewFile,BufRead *.wsgi set filetype=python
  au BufNewFile,BufRead  Vagrantfile set filetype=ruby

  " removes current htmldjango detection located at $VIMRUNTIME/filetype.vim
  au! BufNewFile,BufRead *.html,*.htm
  au  BufNewFile,BufRead,BufWrite *.html,*.htm  call FThtml()

  " Better htmldjango detection
  func! FThtml()
    let n = 1
    while n < 10 && n <= line("$")
      if getline(n) =~ '\<DTD\s\+XHTML\s'
        setf xhtml
        return
      endif
      if getline(n) =~ '{%\s*\(extends\|block\|load\|comment\|if\|for\)\>'
        setf htmldjango
        return
      endif
      let n = n + 1
    endwhile
    setf html
  endfunc
augroup END

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
    colorscheme lucius
    LuciusDark
endif

" Mouse support
if has("mouse")
    set mouse=a
endif

" Folding
set foldmethod=manual
au FileType text setlocal foldmethod=marker

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
let g:syntastic_python_flake8_args='--ignore=E12'
nmap <leader>e :SyntasticToggleMode<CR>

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 0
let g:neocomplete#data_directory = '~/.cache/vim/neocomplete'

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '[^. \t]\.\w*\|import \w\|from \w'

" Tab completion in menus
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" ultisnips Settings
let g:UltiSnipsExpandTrigger = "<c-j>"
"let g:UltiSnipsListSnippets = "<c-j>"
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "snippets"]
let g:UltiSnipsEditSplit = "vertical"

" gundo plugin (only works with vim >= 7.3
if v:version >= 703 && has("python")
    nnoremap <F5> :GundoToggle<CR>
else
    let g:gundo_disable = 1
endif

" Unite.vim
let g:unite_winheight = 30
let g:unite_split_rule = 'botright'
let g:unite_force_overwrite_statusline = 0
let g:unite_source_history_yank_enable = 1

call unite#filters#matcher_default#use(['matcher_glob', 'matcher_fuzzy'])
call unite#custom#source('buffer,file,file_mru,file_rec,file_rec/async',
            \ 'sorters', ['sorter_length', 'sorter_rank'])

" Unite command maps
nnoremap <leader>f :<C-u>Unite -buffer-name=files     -start-insert file_rec/async:!<CR>
nnoremap <leader>b :<C-u>Unite -buffer-name=buffers   -start-insert buffer<CR>
nnoremap <leader>a :<C-u>Unite -buffer-name=grep      grep:.<CR>
nnoremap <leader>y :<C-u>Unite -buffer-name=yank      history/yank<CR>
nnoremap <leader>u <C-o>:<C-u> Unite ultisnips<CR>

" Unite buffer settings
au FileType unite call s:unite_buf_settings()
function! s:unite_buf_settings()
    " exiting
    nmap <buffer> <ESC> <Plug>(unite_exit)
    nmap <buffer> <C-c> <Plug>(unite_all_exit)
    imap <buffer> <C-c> <ESC><Plug>(unite_all_exit)
    nmap <buffer> <C-g> <C-c>
    imap <buffer> <C-g> <C-c>

    " actions
    imap <silent><buffer><expr> <C-Enter> unite#do_action('tabopen')
    imap <silent><buffer><expr> <C-s> unite#do_action('split')
    imap <silent><buffer><expr> <C-x> unite#do_action('split')
    imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')

    " navigation
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction


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
inoremap <A-j> <ESC>gt
inoremap <A-k> <ESC>gT
if has("gui_running")
    noremap <C-TAB> gt
    noremap <C-S-TAB> gT
    noremap <S-A-j> gt
    noremap <S-A-k> gT
    inoremap <S-A-j> <ESC>gt
    inoremap <S-A-k> <ESC>gT
endif

" splits
nmap <silent> <leader>v :vsplit<CR>
nmap <silent> <leader>s :split<CR>

" Show syntax highlighting groups for word under cursor
nmap <leader>sy :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Quickly edit & source vimrc
nmap <silent> <leader>ev :e $HOME/.vim/vimrc<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
