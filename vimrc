" Use pathogen for plugins - install plugins under ~/.vim/bundle/
let g:pathogen_disabled = []
" These plugins require python support
if !has('python')
    call add(g:pathogen_disabled, 'ultisnips')
    call add(g:pathogen_disabled, 'gundo')
    call add(g:pathogen_disabled, 'jedi')
endif
" These plugins require lua support
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
set timeoutlen=500 ttimeoutlen=50

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
  au BufNewFile,BufRead *.conf set filetype=conf
  au BufNewFile,BufRead *.ejs set filetype=html

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

" airline
let g:airline_left_sep=''
let g:airline_right_sep=''
if ! has("gui_running")
    let g:airline_theme = 'powerlineish'
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

" netrw
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_preview = 1
let g:netrw_winsize = 25
let g:netrw_banner = 0

" tree mode
let g:netrw_liststyle = 3

" Toggle Vexplore
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      exec 'Vexplore ' . getcwd()
      let t:expl_buf_num = bufnr("%")
  endif
endfunction

map <silent> <f12> :call ToggleVExplorer()<CR>

let g:vim_json_syntax_conceal = 0


"""""""""""""""""
" Plugin Settings
"""""""""""""""""

" what search programs are available
let s:has_ag = executable('ag')

" Syntastic settings
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_auto_jump = 0
let g:syntastic_auto_loc_list = 2
let g:syntastic_python_flake8_args='--ignore=E12'
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_json_checkers = ['jsonlint']
nmap <leader>e :SyntasticToggleMode<CR>

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 0
let g:neocomplete#data_directory = '~/.cache/vim/neocomplete'

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '[^. \t]\.\w*\|from \w\+\s\+import \w'


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
let g:unite_winheight = 25
let g:unite_split_rule = 'botright'
let g:unite_force_overwrite_statusline = 0
let g:unite_source_history_yank_enable = 1
let g:unite_enable_smart_case = 1
let g:unite_source_rec_max_cache_files = 5000
let g:unite_data_directory = '~/.cache/vim/unite'

if s:has_ag
    let g:unite_source_rec_async_command = 'ag -l .'
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
end

call unite#custom#source(
            \ 'buffer,file,file_mru,file_rec,file_rec/async',
            \ 'sorters', ['sorter_length'])

" Unite command maps
function! UniteCmd(action, arguments)
    return ":\<C-u>Unite " . a:action . " " . a:arguments . "\<CR>"
endfunction

nnoremap <silent><expr><leader>f UniteCmd(
                \ 'file' . (expand('%') == '' ? '' : ':%:h') .
                \' file_rec/async:!' . (expand('%') == '' ? '' : ':%:h'),
            \'-start-insert -buffer-name=files')
nnoremap <silent><expr><leader>b UniteCmd('buffer', '-start-insert -buffer-name=buffer')
nnoremap <silent><expr><leader>a UniteCmd('grep:.', '-buffer-name=grep')
nnoremap <silent><expr><leader>y UniteCmd('history/yank', '-buffer-name=yank')
nnoremap <silent><expr><leader>u UniteCmd('ultisnips', '-buffer-name=ultisnips')
nnoremap <silent><expr><leader>o UniteCmd('outline', '-buffer-name=outline')
nnoremap <silent><expr><leader>h UniteCmd('help', '-start-insert -buffer-name=help')
nnoremap <silent><expr><leader>r UniteCmd('file_mru', '-start-insert')

" Unite buffer settings
au FileType unite call s:unite_buffer_maps()
function! s:unite_buffer_maps()
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

" surround
let g:surround_no_insert_mappings = 1

" goyo (distraction free writing)
map <leader>` :Goyo<CR>

function! s:goyo_before()
    noremap     <buffer> <silent> <Up> g<Up>
    noremap     <buffer> <silent> <Down> g<Down>
    noremap     <buffer> <silent> k gk
    noremap     <buffer> <silent> j gj
    inoremap    <buffer> <silent> <Up> <C-o>g<Up>
    inoremap    <buffer> <silent> <Down> <C-o>g<Down>
    set scrolloff=999
    set linebreak
endfunction

function! s:goyo_after()
    unmap     <buffer>  <Up>
    unmap     <buffer>  <Down>
    unmap     <buffer>  k
    unmap     <buffer>  j
    iunmap    <buffer>  <Up>
    iunmap    <buffer>  <Down>
    set scrolloff=3
    set nolinebreak
endfunction

let g:goyo_callbacks = [function('s:goyo_before'), function('s:goyo_after')]

let g:instant_markdown_autostart = 0

"""""""""""""""""
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
