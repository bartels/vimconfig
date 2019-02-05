scriptencoding utf-8

" Plugins ---------------------------------------------------------------- {{{1

" Always use system python (even when inside virtualenv)
let g:python_host_prog = substitute(system('which -a python | tail -n1'), '\n', '', 'g')
let g:python3_host_prog = substitute(system('which -a python3 | tail -n1'), '\n', '', 'g')

call plug#begin('~/.vim/plugged')

" Editing plugins
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-abolish'
Plug 'wellle/targets.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'
Plug 'junegunn/goyo.vim'
Plug 'editorconfig/editorconfig-vim'

" Theme plugins
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jonathanfilip/vim-lucius'

" Utilities / Helpers
Plug 'tpope/vim-eunuch'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'urbainvaes/vim-tmux-pilot'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'chrisbra/Colorizer'
Plug 'jamessan/vim-gnupg'

" Syntax Checking
Plug 'w0rp/ale'

" Language Server
let s:use_lc = has('nvim')
if s:use_lc
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
endif

" Code Completion
let s:use_deoplete = has('nvim') && has('python3')
if s:use_deoplete
    Plug 'Shougo/echodoc.vim'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/neco-syntax'
    Plug 'Shougo/neco-vim'
    Plug 'wellle/tmux-complete.vim'
endif

" Snippets
if has('python3')
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endif

" Python
Plug 'hynek/vim-python-pep8-indent'

" Markup/HTML
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'

" CSS
Plug 'hail2u/vim-css3-syntax'
Plug 'groenewege/vim-less'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install --prod'  }

" nginx
Plug 'chr4/nginx.vim'

" Cypher (.cql)
Plug 'neo4j-contrib/cypher-vim-syntax'

" graphql
Plug 'jparise/vim-graphql'

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
set history=10000                 " command history entries
set updatetime=1000
set diffopt=filler,vertical

if has('shada')
    " how much info to store in shada (previously viminfo)
    set shada=!,'10000,<100,s100,h
endif

" Folding
set foldmethod=manual
autocmd vimrc FileType text setlocal foldmethod=marker

" Update buffer when a file changes outside of vim
set autoread
autocmd vimrc FocusGained,BufEnter,CursorHold,CursorHoldI * silent! checktime

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


let g:is_bash = 1 " default to bash when no shebang

" Files to use closetag plugin
let g:closetag_filenames = '*.xml,*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ts,*.tsx'
let g:closetag_filetypes = 'xml,html,javascript'
let g:closetag_close_shortcut = ',>'

" vim-gnupg
let g:GPGPreferSymmetric = 1


" Keyboard --------------------------------------------------------------- {{{1

" key sequence timeouts
set timeout timeoutlen=350 ttimeoutlen=50

" Fixes for regular vim keyboard/terminal issues (not nvim)
if ! has('nvim')
    " Allow terminal vim to recognize Alt key combos
    " see: https://stackoverflow.com/questions/6778961/
    if ! has('gui_running')
        let s:c='a'
        while s:c <=# 'z'
            exec 'set <A-'.s:c.">=\e".s:c
            exec "imap \e".s:c.' <A-".s:c.">'
            let s:c = nr2char(1+char2nr(s:c))
        endw
    endif

    " Allow terminal vim to recognize XTerm escape sequences for Page and Arrow
    " keys combined with modifiers such as Shift, Control, and Alt.
    if &term =~# '^screen' || &term =~# '^tmux'
        " Page keys: https://github.com/ddollar/tmux/blob/master/FAQ
        execute "set t_kP=\e[5;*~"
        execute "set t_kN=\e[6;*~"

        " Arrow keys: http://unix.stackexchange.com/a/34723
        execute "set <xUp>=\e[1;*A"
        execute "set <xDown>=\e[1;*B"
        execute "set <xRight>=\e[1;*C"
        execute "set <xLeft>=\e[1;*D"
    endif
endif


" UI --------------------------------------------------------------------- {{{1

set title                         " title in terminal window
let &titleold = hostname()        " reset title to hostname on exit
set number relativenumber         " show line numbers
set display+=lastline             " always show as much of last line of file
set laststatus=2                  " always show the statusline
set tabpagemax=50                 " increase max tabpages
set incsearch hlsearch            " highlight search terms as you type
set scrolloff=3                   " number of context lines while scrolling
set sidescrolloff=3               " number of context columns
set shortmess+=Ic                 " turn off intro text
set noshowmode                    " don't show message on last line for insert/visual/replace mode

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
set completeopt=noinsert,noselect,menuone

" Enable mouse support
if has('mouse')
    set mouse=a

    " Fixes scrolling when in insert mode for regular vim when using tmux.
    " Otherwise, randome characters get inserted into the buffer. works with
    " gnome-terminal & tmux, not sure about other terminals.
    if ! has('nvim') && (&term =~# '^screen' || &term =~# '^tmux')
        set ttymouse=sgr
    endif
endif

" Use system clipboard for yank/paste
if has('unnamedplus') || has('nvim')
    set clipboard=unnamedplus
endif

" Open help in vertical split
autocmd! vimrc FileType help :wincmd H | :vert resize 90


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
        hi StatusLineNC guifg=#767676 guibg=#444444 ctermfg=242 ctermbg=236
        hi TabLineSel   guifg=#303030 guibg=#bcbcbc ctermfg=236 ctermbg=249
    endif
endfunc

" gui colorscheme
if has('gui_running')
    set background=light
    colorscheme lucius
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

    " refresh after sourcing vimrc
    autocmd! vimrc User SourceVimrc AirlineRefresh
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


" Editorconfig ----------------------------------------------------------- {{{1
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']


" ALE -------------------------------------------------------------------- {{{1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_info_str = 'I'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%] %code%'

let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'normal'  " only lint for normal mode hanges
let g:ale_lint_on_insert_leave = 1         " lint when leaving insert mode
let g:ale_lint_delay = 0

autocmd vimrc BufWinEnter * call ale#Queue(0)

" bindings
nmap <silent> <leader>k <Plug>(ale_previous_wrap)
nmap <silent> <leader>j <Plug>(ale_next_wrap)
nmap <F8> <Plug>(ale_fix)

let g:ale_linters = {}

" javascript
let g:ale_linters.javascript = ['eslint', 'flow']
let g:ale_javascript_eslint_executable = executable('eslint_d') ? 'eslint_d' : 'eslint'
let g:ale_javascript_eslint_use_global = executable('eslint_d') ? 1 : 0
let g:ale_pattern_options = {
\ '.eslintrc$': {'ale_linters': [], 'ale_fixers': []},
\ '.stylelintrc$': {'ale_linters': [], 'ale_fixers': []},
\ '.babelrc$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}

" typescript
let g:ale_linters.typescript = ['tsserver']

" Fixers
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'python': ['autopep8']
\}

" vim
let g:ale_vim_vint_show_style_issues = 1


" LanguageClient --------------------------------------------------------- {{{1
if s:use_lc
    let g:LanguageClient_serverCommands = {
    \   'python': ['pyls'],
    \ }

    " javascript - flow setup
    if !empty(findfile('.flowconfig', '.;'))
        let g:LanguageClient_serverCommands.javascript = ['flow', 'lsp']
        let g:LanguageClient_serverCommands['javascript.jsx'] = ['flow', 'lsp']
    endif

    " typescript setup
    let g:LanguageClient_serverCommands.typescript = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescript.jsx'] = ['javascript-typescript-stdio']

    let g:LanguageClient_diagnosticsEnable = 0 " disable since w're using ale
    let g:LanguageClient_diagnosticsDisplay = { 1: { 'signTexthl': 'ErrorMsg' } } " fix color of error sings

    " custom commands
    command! LCContextMenu call LanguageClient_contextMenu()
    command! LCHover call LanguageClient#textDocument_hover()
    command! LCDefinition call LanguageClient#textDocument_definition()
    command! LCTypeDefinition call LanguageClient#textDocument_typeDefinition()
    command! LCImplementation call LanguageClient#textDocument_implementation()
    command! LCRename call LanguageClient#textDocument_rename()
    command! LCDocumentSymbol call LanguageClient#textDocument_documentSymbol()
    command! LCReferences call LanguageClient#textDocument_references()
    command! LCCodeAction call LanguageClient#textDocument_codeAction()
    command! LCFormat call LanguageClient#textDocument_formatting()
    command! LCRangeFormat call LanguageClient#textDocument_rangeFormatting()
    command! LCWorkspaceSymbol call LanguageClient#workspace_symbol()
endif

" LanguageClient mappings
function! LanguageClientMaps()
    if s:use_lc
        nnoremap <buffer> <F2> :LCContextMenu<CR>
        nnoremap <buffer> <silent> K :LCHover<CR>
        nnoremap <buffer> <silent> gd :LCDefinition<CR>
        nnoremap <buffer> <silent> <leader>d :LCDefinition<CR>
        nnoremap <buffer> <silent> <leader>r :LCReferences<CR>
    endif
endfunction


" Deoplete --------------------------------------------------------------- {{{1
if s:use_deoplete
    let g:deoplete#enable_at_startup = 1

    " options
    call deoplete#custom#option({
    \  'auto_complete_delay': 20,
    \  'auto_refresh_delay': 20,
    \ })

    " call deoplete#custom#source('_', 'matchers', ['matcher_head'])
    call deoplete#custom#source('LanguageClient', 'input_patterns', {
    \   'python': "[\w\)\]\}\'\"]+\.\w*$|^\s*@\w*$|^\s*from\s+[\w\.]*(?:\s+import\s+(?:\w*(?:,\s*)?)*)?|^\s*import\s+(?:[\w\.]*(?:,\s*)?)*",
    \ })

    " manual completion
    inoremap <expr> <C-SPACE> call deoplete#manual_complete(['LanguageClient'])

    " tab completion
    inoremap <expr> <CR>    pumvisible() ? "\<c-y>" : "\<CR>"
    inoremap <expr> <TAB>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"
endif


" UltiSnips -------------------------------------------------------------- {{{1
let g:UltiSnipsExpandTrigger = '<c-j>'
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

    " hide statusline
    augroup Fzf
        autocmd!
        autocmd FileType fzf setlocal nonumber norelativenumber
    augroup END

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
        let l:command = $FZF_DEFAULT_COMMAND . (a:bang ? ' --all-types ' : '')
        return fzf#vim#files(l:search_root, {'source': l:command}, a:bang)
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
    command! -bang -nargs=* -complete=dir
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


" Markdown-preview ------------------------------------------------------- {{{1

let g:mkdp_browser = 'google-chrome'
nmap <leader>m :MarkdownPreview<CR>


" tmux-pilot ------------------------------------------------------------- {{{1

" Fix: tmux-pilot maps conflict with fzf maps
if exists(':tnoremap')
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
nnoremap <silent> <leader><space> :noh<CR>

" creating window splits
nnoremap <silent> <leader>v :vsplit<CR>
nnoremap <silent> <leader>s :split<CR>

" C-Space as omnicomplete shortcut
inoremap <C-Space> <C-x><C-o>

" Tabpage mappings
nnoremap <silent> <leader>t :tabnew<CR>
nnoremap <silent> <leader>w :close<CR>
nnoremap <silent> <leader>x :bd<CR>
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
nnoremap <silent> <leader>sv :source $MYVIMRC<CR> :silent doautocmd <nomodeline> User SourceVimrc<CR>

" Abbreviations

" Allow command-line abbreviations that start at the begining and do not apply
" for search patterns (like normal cabbrev does).
function! s:ccabbrev(abbrev, expansion)
    exec 'cnoreabbrev ' . a:abbrev .
            \ ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ' .
            \ '? "' . a:expansion . '" ' .
            \ ': "' . a:abbrev . '"<CR>'
endfunction

" Cabbrev command
command! -nargs=+ Cabbrev call s:ccabbrev(<f-args>)

" Fugitive abbreviations
Cabbrev gdiff Gdiff
Cabbrev gwrite Gwrite
Cabbrev gmove Gmove
Cabbrev gblame Gblame
Cabbrev gcommit Gcommit
Cabbrev gremove Gremove
Cabbrev gdelete Gdelete

" Custom Functions ------------------------------------------------------- {{{1

" Toggle diff mode on visible windows
function! g:ToggleWinDiff()
    if &diff
        exec ':diffoff!'
    else
        " exec ':windo diffthis'
        " diffthis, but filter out some buftypes
        exec ':windo if &buftype !~ ''quickfix\|locationlist\|help'' | diffthis | endif'
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
  let stack = map(synstack(line('.'), col('.')), 'synIDattr(v:val, ''name'')')
  let link = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  echo join(stack, ' > ') . ' : ' . link
endfunc

nnoremap <leader>sy :call <SID>SynStack()<CR>

" vim:foldmethod=marker:foldlevel=1
