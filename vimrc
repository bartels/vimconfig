" Use pathogen to modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
call pathogen#runtime_append_all_bundles()
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
filetype indent plugin on

" Indenting
set autoindent

"Show matching parens as typing
set showmatch
let loaded_matchparen = 1

" Mouse support
if has("mouse")
    set mouse=a
endif

" Folding
set foldmethod=manual
autocmd BufRead *.txt set foldmethod=marker

" Fix annoying indenting for xml files
autocmd BufEnter *.html setlocal indentexpr=
autocmd BufEnter *.htm setlocal indentexpr=
autocmd BufEnter *.xml setlocal indentexpr=

" Highlight parts of lines longer than 79 columns
autocmd filetype python highlight OverLength ctermbg=black guibg=black
autocmd filetype python match OverLength /\%80v.\+/
autocmd BufRead,BufNewFile *.wsgi set filetype=python

" omnicomplete customizations
set completeopt=longest,menuone
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" cakephp filetypes
autocmd BufRead,BufNewFile *.thtml set filetype=php
autocmd BufRead,BufNewFile *.ctp set filetype=php

" Use htmldjango syntax for .html files
autocmd BufEnter *.html set filetype=htmldjango.html

" supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType="<c-x><c-p>"


" View for invisible chars when using set list
set listchars=tab:>-,eol:$


" surround plugin for django templates
let g:surround_{char2nr("b")} = "{% block\1 \r..*\r &\1 %}\r{% endblock %}"
let g:surround_{char2nr("i")} = "{% if\1 \r..*\r &\1 %}\r{% endif %}"
let g:surround_{char2nr("w")} = "{% with\1 \r..*\r &\1 %}\r{% endwith %}"
let g:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"
let g:surround_{char2nr("f")} = "{% for\1 \r..*\r &\1 %}\r{% endfor %}"

" Key Mappings

" Change the mapleader from \ to ,
let mapleader=","

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
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
inoremap <Nul> <C-X><C-O>

" Fuzzy Finder
nmap <silent> <leader>f :FufFile<CR>
let g:fuf_keyOpen = '<CR>'
let g:fuf_keyOpenTabpage = '<S-CR>'

" tabs
nmap <silent> <leader>t :tabnew<CR>

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
