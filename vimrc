scriptencoding utf-8

" Plugins ---------------------------------------------------------------- {{{1

call plug#begin('~/.vim/plugged')

" Editing plugins
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'wellle/targets.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'
Plug 'junegunn/goyo.vim'

" Theme plugins
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jonathanfilip/vim-lucius'
Plug 'lifepillar/vim-solarized8'

" Filetype/Syntax plugins
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'pangloss/vim-javascript'
Plug 'hail2u/vim-css3-syntax'
Plug 'groenewege/vim-less'
Plug 'elzr/vim-json'
Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'
Plug 'flowtype/vim-flow', { 'for': ['javascript', 'jsx'] }
Plug 'hynek/vim-python-pep8-indent'

" Utilities / Helpers
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'chrisbra/Colorizer'
Plug 'JamshedVesuna/vim-markdown-preview'

" Syntax Checking
Plug 'w0rp/ale'

" Code Completion
let s:use_deoplete = has('nvim') && has('python3')
let s:use_neocomplete = !s:use_deoplete && has('lua')

if s:use_deoplete
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-jedi', { 'for': 'python' }
elseif s:use_neocomplete
    Plug 'Shougo/neocomplete'
    Plug 'Shougo/vimproc', { 'do': 'make' }
endif

if has('python')
    Plug 'davidhalter/jedi-vim', { 'for': 'python' }
    Plug 'jmcantrell/vim-virtualenv', { 'for': 'python' }
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endif

call plug#end()


" Misc ------------------------------------------------------------------- {{{1

" set up vimrc group for autocmd
augroup vimrc
    autocmd!
augroup END

set hidden                        " switch buffers without needing to save
set backspace=indent,eol,start    " more powerful backspacing
set fileformats+=mac              " handle 'mac' style EOLs
set modeline                      " alow modlines in files
set history=1000                  " command history entries

if has('shada')
    " how much info to store in shada (previously viminfo)
    set shada=!,'10000,<100,s100,h
endif

" Folding
set foldmethod=manual
autocmd vimrc FileType text setlocal foldmethod=marker

" Update buffer when a file changes outside of vim
set autoread
autocmd vimrc CursorHold,CursorHoldI * checktime

" Use comma for mapleader
" NOTE: set before defining mappings that use <leader>
let g:mapleader=','

let g:loaded_matchparen = 1  " prevent loading matchparen

" Load matchit:  extended matching with '%' key
runtime macros/matchit.vim

" Use ~/.cache/vim/ for swap & backup files
silent! call mkdir(expand('~/.cache/vim/swap', 'p'))
silent! call mkdir(expand('~/.cache/vim/backup', 'p'))
set directory^=~/.cache/vim/swap//
set backupdir^=~/.cache/vim/backup//
if ! has('nvim')
    set viminfo+=n~/.cache/vim/viminfo
endif

" grep
if executable('ag')
    set grepprg=ag\ --vimgrep
endif


" Spaces & Tabs ---------------------------------------------------------- {{{1

set tabstop=4           " number of visual spaces per tab
set softtabstop=4       " number of spaces per tab for editing commands
set shiftwidth=4        " spaces to use for each step of indent
set shiftround          " rounds indents to multiple of 'shiftwidth'
set expandtab           " Insert spaces instead of tabs
set smarttab


" Filetypes -------------------------------------------------------------- {{{1

syntax enable               " Enable syntax feature
filetype plugin indent on   " Enable filetype plugins & indent
set autoindent              " Copy indent from previous line

" Filetype handling
augroup FileTypeDetect
    autocmd!

    " These filetypes map to other types
    autocmd BufNewFile,BufRead *.thtml,*.ctp set filetype=php
    autocmd BufNewFile,BufRead *.wsgi set filetype=python
    autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
    autocmd BufNewFile,BufRead *.conf set filetype=conf
    autocmd BufNewFile,BufRead requirements.txt,requirements_*.txt set filetype=conf
    autocmd BufNewFile,BufRead *.ejs set filetype=html
    autocmd BufNewFile,BufRead .eslintrc,.babelrc set filetype=javascript

    " Removes default django template detection in $VIMRUNTIME/filetype.vim
    autocmd! BufNewFile,BufRead *.html,*.htm

    " Better django template detection
    " - looks for a few additional Django tag types.
    autocmd BufNewFile,BufRead,BufWrite *.html,*.htm call FThtml()
augroup END

" Distinguish between HTML, XHTML and Django
" custom/improved version than in runtime/filetype.vim
func! FThtml()
    let l:n = 1
    while l:n < 10 && l:n <= line('$')
      if getline(l:n) =~# '\<DTD\s\+XHTML\s'
        setf xhtml
        return
      endif
      if getline(l:n) =~# '{%\s*\(extends\|block\|load\|comment\|if\|for\)\>\|{#\s\+'
        setf htmldjango
        return
      endif
      let l:n = l:n + 1
    endwhile
    setf html
endfunc

" Files to use closetag plugin
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx'

" Disable conceal feature in json files (vim-json)
let g:vim_json_syntax_conceal = 0

" Support jsx syntax in .js files (vim-jsx)
let g:jsx_ext_required = 0

" pangloss vim-javascript
let g:javascript_plugin_flow = 1

" flowtype
let g:flow#enable = 0

" skeleton files
func! ReadSkel(skel_file)
    execute '0read' '~/.vim/skeletons/' . a:skel_file
    " Removes empty line at bottom
    normal! Gddgg
endfunc

augroup skeletons
    autocmd!

    " Django
    autocmd BufNewFile models.py call ReadSkel('models.py')
    autocmd BufNewFile urls.py call ReadSkel('urls.py')
    autocmd BufNewFile tests.py call ReadSkel('tests.py')

    " React
    autocmd BufNewFile **/components/*.js call ReadSkel('component.js')
augroup END

" Keyboard --------------------------------------------------------------- {{{1

" key sequence timeouts
set timeout timeoutlen=500 ttimeoutlen=50

" Allow terminal vim to recognize Alt key combos
" see: https://stackoverflow.com/questions/6778961/
if ! has('gui_running') && ! has('nvim')
    let s:c='a'
    while s:c <=# 'z'
        exec 'set <A-'.s:c.">=\e".s:c
        exec "imap \e".s:c.' <A-".s:c.">'
        let s:c = nr2char(1+char2nr(s:c))
    endw
endif

" Allow terminal vim to recognize XTerm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
if &term =~# '^screen'
    " Page keys: http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
    execute "set t_kP=\e[5;*~"
    execute "set t_kN=\e[6;*~"

    " Arrow keys: http://unix.stackexchange.com/a/34723
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif


" UI --------------------------------------------------------------------- {{{1

set title                         " title in terminal window
set number relativenumber         " show line numbers
set display+=lastline             " always show as much of last line of file
set laststatus=2                  " always show the statusline
set tabpagemax=50                 " increase max tabpages
set incsearch hlsearch            " highlight search terms as you type
set scrolloff=3                   " number of context lines while scrolling
set sidescrolloff=3               " number of context columns

" nvim only
if has('nvim')
    set inccommand=nosplit        " shows incremental results of command
endif

" Invisible chars to use with :set list
set listchars=tab:▸\ ,trail:·
set list

" Command line completion options
set wildmenu
set wildmode=longest,list
set wildignore=*~,*.bak,*.o,*.pyc,*.pyo

" Insert mode completion options
set completeopt=menuone,longest

" Enable mouse support
if has('mouse')
    set mouse=a

    " Fixes scrolling when in insert mode for regular vim when using tmux.
    " Otherwise, randome characters get inserted into the buffer. works with
    " gnome-terminal & tmux, not sure about other terminals.
    if ! has('nvim') && &term =~# '^screen-256color'
        set ttymouse=sgr
    endif
endif

" Use system clipboard for yank/paste
if has('unnamedplus') || has('nvim')
    set clipboard=unnamedplus
endif


" Colors ----------------------------------------------------------------- {{{1

" Enable true color
if has('termguicolors')
    set termguicolors

    " The following is needed inside tmux (vim only)
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
endif

" lucius dark colorscheme overrides
function! PatchLucius()
    if &background ==# 'dark'
        hi StatusLineNC guifg=#767676 guibg=#303030 ctermfg=242 ctermbg=236
        hi TabLineSel   guifg=#303030 guibg=#bcbcbc ctermfg=236 ctermbg=249
    endif
endfunc

" gui colorscheme
if has('gui_running')
    colorscheme solarized8_light
" terminal colorscheme
else
    set background=dark
    autocmd vimrc ColorScheme lucius call PatchLucius()
    colorscheme lucius
endif

" Colorizer mappings
nmap <silent> <leader>cC <Plug>Colorizer
nmap <silent> <leader>cT <Plug>ColorContrast
nmap <silent> <leader>cF <Plug>ColorFgBg


" Airline ---------------------------------------------------------------- {{{1
if ! has('gui_running')
    let g:airline_powerline_fonts=1
    let g:airline_right_sep=''

    "" tabline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#tab_min_count = 2
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline#extensions#tabline#show_tab_type = 0
    let g:airline#extensions#tabline#show_splits = 0
    let g:airline#extensions#tabline#show_buffers = 0

    " override some theme colors
    let g:airline_theme_patch_func = 'AirlineThemePatch'
    function! AirlineThemePatch(palette)
        if g:airline_theme ==# 'lucius' && &background ==# 'dark'
            " darker normal/visual mode statusline bg
            let a:palette.normal.airline_c[1] = '#303030'
            let a:palette.normal.airline_c[3] = 236
        endif
    endfunction
else
    let g:airline_left_sep=''
    let g:airline_right_sep=''
endif


" Netrw ------------------------------------------------------------------ {{{1
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_preview = 1
let g:netrw_winsize = 25
let g:netrw_banner = 0
let g:netrw_liststyle = 3  " tree mode

" Toggle Vexplore
function! ToggleVExplorer()
  if exists('t:expl_buf_num')
      let l:expl_win_num = bufwinnr(t:expl_buf_num)
      if l:expl_win_num != -1
          let l:cur_win_nr = winnr()
          exec l:expl_win_num . 'wincmd w'
          close
          exec l:cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      exec 'Vexplore ' . getcwd()
      let t:expl_buf_num = bufnr('%')
  endif
endfunction

noremap <silent> <f12> :call ToggleVExplorer()<CR>


" ALE -------------------------------------------------------------------- {{{1
let g:ale_lint_on_save = 1
let g:ale_lint_delay = 250
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" This is to prevent ALE from running during insert mode changes, for which
" there is no option. ALE will run when text is changed in normal mode or
" leaving insert mode.
let g:ale_lint_on_text_changed = 0
autocmd vimrc TextChanged,InsertLeave * call ale#Queue(g:ale_lint_delay)

nmap <silent> <leader>k <Plug>(ale_previous_wrap)
nmap <silent> <leader>j <Plug>(ale_next_wrap)

" javascript
let g:ale_javascript_eslint_executable = executable('eslint_d') ? 'eslint_d' : 'eslint'
let g:ale_javascript_eslint_use_global = executable('eslint_d') ? 1 : 0

" vim
let g:ale_vim_vint_show_style_issues = 1


" NeoComplete ------------------------------------------------------------ {{{1
if s:use_neocomplete
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#data_directory = '~/.cache/vim/neocomplete'

    " So we can override input paterns that trigger completions
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif

    " customize when python omni completion is triggered
    let g:neocomplete#force_omni_input_patterns.python = '[^. \t]\.\w*\|from \w\+\s\+import \w'

    " So .less files use omni same as .css
    let g:neocomplete#sources#omni#input_patterns.less = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'

    " Tab completion in menus
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
endif


" Deoplete --------------------------------------------------------------- {{{1
if s:use_deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#enable_camel_case = 1
    let g:deoplete#auto_complete_delay = 20

    " Use head matcher
    call deoplete#custom#set('_', 'matchers', ['matcher_head'])

    " disable jedi completions since deoplete is used
    let g:jedi#completions_enabled = 0

    let g:deoplete#omni#input_patterns = {}
    let g:deoplete#omni#input_patterns.javascript = ['[^. \t0-9]\.([a-zA-Z_]\w*)?']

    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
endif

" UltiSnips -------------------------------------------------------------- {{{1
let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsSnippetDirectories = ['UltiSnips']
let g:UltiSnipsEditSplit = 'vertical'


" UndoTree --------------------------------------------------------------- {{{1
" requires vim >= 7.3
if v:version >= 703
    nnoremap <F5> :UndotreeToggle<CR>
    let g:undotree_SplitWidth = 44
    let g:undotree_TreeNodeShape  = 'o'
endif


" FZF -------------------------------------------------------------------- {{{1
" If fzf is installed (.fzf directory exists)
if isdirectory(expand('~/.fzf'))
    let g:fzf_is_installed = 1

    " loads fzf as vim plugin
    set runtimepath+=~/.fzf

    " Use ag if available as default fzf command
    if executable('ag')
        let $FZF_DEFAULT_COMMAND = 'ag -g ""
                    \ --nogroup
                    \ --follow
                    \ --depth 50
                    \ --hidden
                    \ --ignore .git'
    endif

    " fzf defaults
    let $FZF_DEFAULT_OPTS='
                \ --exact
                \ --tiebreak=length
                \ --inline-info
                \ --cycle
                \ --bind=tab:toggle-up,btab:toggle-down,alt-a:toggle-all
                \ --toggle-sort=ctrl-r'


    " Finds the git project root
    function! s:find_git_root(...)
        if executable('git')
            let l:dir = empty(a:1) ? '.' : a:1
            let l:cmd = 'cd ' . shellescape(l:dir) . ' && ' .
                        \ 'git rev-parse --show-toplevel 2> /dev/null'
            let l:git_root = system(l:cmd)[:-2]
            if getcwd() == l:git_root
                let l:git_root = '.'
            endif
            return l:git_root
        else
            return '.'
        endif
    endfunction

    " fzf search files from git project root
    function! s:fzf_projectfiles(dir, bang)
        let l:search_root = s:find_git_root(a:dir)
        return fzf#vim#files(l:search_root, {'source': $FZF_DEFAULT_COMMAND}, a:bang)
    endfunction

    " fzf ag command with with custom options
    function! s:fzf_ag(query, dir, bang)
        let l:search_root = s:find_git_root(a:dir)
        let l:opts = '--hidden --ignore .git'
        return fzf#vim#ag(a:query, l:opts, {'dir': l:search_root}, a:bang)
    endfunction

    " fzf ag command with prompt for search pattern
    function! s:fzf_ag_prompt(dir, bang)
        return s:fzf_ag(input('Pattern: '), a:dir, a:bang)
    endfunction

    " :ProjectFiles - :Files but search from project repo root
    command! -bang -nargs=? -complete=dir
                \ ProjectFiles
                \ call s:fzf_projectfiles(<q-args>, <bang>0)

    " :AgPrompt - :Ag but prompt for search pattern
    command! -bang -nargs=? -complete=dir
                \ AgPrompt call s:fzf_ag_prompt(<q-args>, <bang>0)

    " :Ag but with customized options
    autocmd vimrc VimEnter * command! -bang -nargs=* -complete=dir
                \ Ag call s:fzf_ag(<q-args>, '', <bang>0)

    " Bindings
    nnoremap <silent><leader>f :ProjectFiles<CR>
    nnoremap <silent><leader>b :Buffers<CR>
    nnoremap <silent><leader>a :AgPrompt<CR>
    nnoremap <silent><leader>gs :GitFiles?<CR>
    nnoremap <silent><leader>rf :History<CR>
    nnoremap <silent><leader>u :Snippets<CR>
    nnoremap <silent><leader>h :Helptags<CR>
    nnoremap <silent><leader>: :History:<CR>
    nnoremap <silent><leader>/ :History/<CR>
    nmap <leader><tab> <plug>(fzf-maps-n)
    xmap <leader><tab> <plug>(fzf-maps-x)
    omap <leader><tab> <plug>(fzf-maps-o)
endif


" Surround --------------------------------------------------------------- {{{1
let g:surround_no_insert_mappings = 1   " turn off insert mode mappings


" Goyo ------------------------------------------------------------------- {{{1
noremap <leader>` :Goyo<CR>

" Custom settings when in goyo mode
function! s:goyo_enter()
    noremap     <buffer> <silent> <Up> g<Up>
    noremap     <buffer> <silent> <Down> g<Down>
    noremap     <buffer> <silent> k gk
    noremap     <buffer> <silent> j gj
    inoremap    <buffer> <silent> <Up> <C-o>g<Up>
    inoremap    <buffer> <silent> <Down> <C-o>g<Down>
    set scrolloff=999
    set linebreak
    set breakindent
    echo 'Goyo Enter'
endfunction

" Restore settings when leaving goyo mode
function! s:goyo_leave()
    unmap     <buffer>  <Up>
    unmap     <buffer>  <Down>
    unmap     <buffer>  k
    unmap     <buffer>  j
    iunmap    <buffer>  <Up>
    iunmap    <buffer>  <Down>
    set scrolloff=3
    set nolinebreak
    set nobreakindent
    echo 'Goyo Leave'
endfunction

autocmd! vimrc User GoyoEnter nested call <SID>goyo_enter()
autocmd! vimrc User GoyoLeave nested call <SID>goyo_leave()


" Markdown Preview ------------------------------------------------------- {{{1
let g:vim_markdown_preview_toggle = 0
let g:vim_markdown_preview_hotkey = ',p'
let g:vim_markdown_preview_browser = 'Google Chrome'
let g:vim_markdown_preview_github = 1


" tmux-navigator --------------------------------------------------------- {{{1

if exists(':tnoremap')
    " Fix: tmux-navigator maps break fzf pane maps
    function! s:unset_tmux_maps_for_fzf()
        noremap <buffer> <c-h> <Nop>
        tnoremap <buffer> <c-j> <c-n>
        tnoremap <buffer> <c-k> <c-p>
        tnoremap <buffer> <c-l> <Nop>
    endfunction
    autocmd! vimrc FileType fzf call <SID>unset_tmux_maps_for_fzf()
endif


" Key Mappings ----------------------------------------------------------- {{{1

" Prevent jumping back one char when leaving insert mode
inoremap <Esc> <Esc>`^

" Use kj for escape
imap kj <Esc>

" So we can now use <space> for what , does
noremap <space> ,

" Use c-g same as C-c
noremap <C-g> <C-c>
inoremap <C-g> <C-c>
cnoremap <C-g> <C-c>

" Some familiar editing bindings (only work in GUI)
if has('gui_running')
    inoremap <C-DEL> <C-O>dw
    inoremap <C-BACKSPACE> <C-W>
endif

" Easier shortcut for beginning/end of the line
nnoremap <S-H> ^
nnoremap <S-L> $

" Toggle :set list
nnoremap <leader>l :set list!<CR>

" Clear last search highlight
nnoremap <leader><space> :noh<CR>

" creating window splits
nnoremap <silent> <leader>v :vsplit<CR>
nnoremap <silent> <leader>s :split<CR>

" C-Space as omnicomplete shortcut
inoremap <C-Space> <C-x><C-o>

" Tabpage mappings
nnoremap <silent> <leader>t :tabnew<CR>
nnoremap <silent> <leader>w :close<CR>
noremap <A-j> gt
noremap <A-k> gT
inoremap <A-j> <ESC>gt
inoremap <A-k> <ESC>gT

" Tabpage mappings (GUI only)
if has('gui_running')
    noremap <C-TAB> gt
    noremap <C-S-TAB> gT
    noremap <S-A-j> gt
    noremap <S-A-k> gT
    inoremap <S-A-j> <ESC>gt
    inoremap <S-A-k> <ESC>gT
endif

" Save buffer using 'sudo'
" If you accidentally edit a file without permissions, use :w!!
cnoremap w!! w !sudo tee % > /dev/null

" Edit vimrc file
nnoremap <silent> <leader>ev :exec ':e' . resolve($MYVIMRC)<CR>

" Source the vimrc file
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>


" Custom Functions ------------------------------------------------------- {{{1

" Toggle diff mode on visible windows
function! g:ToggleWinDiff()
    if &diff
        exec ':diffoff!'
    else
        exec ':windo diffthis'
    endif
endfunction
nnoremap <silent><leader>dd :call g:ToggleWinDiff()<CR>

" Automatically update diff when making changes
augroup AutoDiffUpdate
    autocmd!
    autocmd InsertLeave * if &diff | diffupdate | let b:old_changedtick = b:changedtick | endif
    autocmd CursorHold *
                \ if &diff &&
                \    (!exists('b:old_changedtick') || b:old_changedtick != b:changedtick) |
                \   let b:old_changedtick = b:changedtick | diffupdate |
                \ endif
augroup END

" Toggle colorcolumn on/off
if exists('+colorcolumn')
    function! g:ToggleColorColumn()
        " Use textwidth but default to 80
        let l:textWidth = (&textwidth ? &textwidth : 79) + 1
        if &colorcolumn
            setlocal colorcolumn&
        else
            let &l:colorcolumn=l:textWidth
        endif
    endfunction

    nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>
endif

" Displays the syntax highlighting group for word under cursor
function! <SID>SynStack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, ''name'')')
endfunc
nnoremap <leader>sy :call <SID>SynStack()<CR>

" vim:foldmethod=marker:foldlevel=0
