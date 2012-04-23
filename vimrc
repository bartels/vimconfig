" Use pathogen to modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
call pathogen#infect()
call pathogen#helptags()
runtime macros/matchit.vim

" Some nice settings
set nocompatible
set number  " line numbering
set title   " display title in terminal window
set hidden  " buffers can be hidden without requiring disk write
set incsearch hlsearch  " highlight and show search terms as you type
set scrolloff=3  " min number of lines of context to show while scrolling
set sidescrolloff=3  " same as above but with columns
set wildmode=longest,list  " sets file completion search to stop at common substring
set wildignore=*~,*.bak,*.o,*.pyc  " ignore these file globs in wildmode

" Don't write pesky backup files
set nobackup
set nowritebackup

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

" Indenting
set autoindent

"Show matching parens as typing
set showmatch
let loaded_matchparen = 1

" Colors
set t_Co=256
if has('gui_running')
    set background=light
else
    set background=dark
endif
let g:solarized_menu=0
let g:solarized_termcolors=256
call togglebg#map("<F6>")
colorscheme solarized

" Mouse support
if has("mouse")
    set mouse=a
endif

" Change the mapleader from \ to ,
let mapleader=","

" Folding
set foldmethod=manual
autocmd BufRead *.txt set foldmethod=marker

" Fix annoying indenting for xml files
autocmd BufEnter *.html setlocal indentexpr=
autocmd BufEnter *.htm setlocal indentexpr=
autocmd BufEnter *.xml setlocal indentexpr=

" wsgi files get python filetype
autocmd BufRead,BufNewFile *.wsgi set filetype=python

" LESS files
autocmd BufNewFile,BufRead *.less set filetype=less

" Vagrantfile
autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby

" JSON files
autocmd BufNewFile,BufRead *.json set filetype=javascript

" omnicomplete customizations
set completeopt=longest,menuone
" autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" python-mode settings
let g:pymode_lint = 0 " Turn off pylint since we're using pyflakes already.
let g:python_highlight_space_errors = 0
let g:pymode_breakpoint_cmd = "import ipdb; ipdb.set_trace() ### XXX BREAKPOINT"

" cakephp filetypes
autocmd BufRead,BufNewFile *.thtml set filetype=php
autocmd BufRead,BufNewFile *.ctp set filetype=php

" Use htmldjango syntax for .html files
autocmd BufEnter *.html set filetype=htmldjango.html

" View for invisible chars when using set list
set listchars=tab:▸\ ,eol:¬
nmap <leader>l :set list!<CR>

" surround plugin for django templates
let g:surround_{char2nr("b")} = "{% block\1 \r..*\r &\1 %}\r{% endblock %}"
let g:surround_{char2nr("i")} = "{% if\1 \r..*\r &\1 %}\r{% endif %}"
let g:surround_{char2nr("w")} = "{% with\1 \r..*\r &\1 %}\r{% endwith %}"
let g:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"
let g:surround_{char2nr("f")} = "{% for\1 \r..*\r &\1 %}\r{% endfor %}"

" ultisnips Settings
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsListSnippets = "<s-tab>"
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "snippets"]
let g:UltiSnipsEditSplit = "vertical"

" gundo plugin (only works with vim >= 7.3
if v:version >= 703
    nnoremap <F5> :GundoToggle<CR>
else
    let g:gundo_disable = 1
endif

" auto-pairs settings
let g:AutoPairsShortcuts = 0
let g:AutoPairsMapCR = 0
let g:AutoPairsCenterLine = 0

" ============
" Key Mappings
" ============

" Escape insert mode
inoremap <Esc> <Esc>`^
imap kj <Esc>

" Clear last search
nnoremap <leader><space> :noh<CR>

" command-t
nnoremap <silent> <leader>f :CommandT<CR>
let g:CommandTAcceptSelectionSplitMap = "<C-s>"
let g:CommandTAcceptSelectionTabMap = "<C-CR>"

" pep8
let g:pep8_map='<leader>8'

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $HOME/.vim/vimrc<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Easy switching between split windows
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k

" Convenient editing shortcuts
imap <C-Enter> <C-o>o
imap <C-S-Enter> <C-o>O

" command completion
inoremap <C-Space> <C-x><C-o>

" tabs
nmap <silent> <leader>t :tabnew<CR>
nmap <silent> <leader>w :bd<CR>

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
