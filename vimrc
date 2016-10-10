" Plugins ---------------------------------------------------------------- {{{1

" Init plugins (vim-plug)
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
Plug 'benekastah/neomake'

" Completion plugins
let use_deoplete = has('nvim') && has('python3')
let use_neocomplete = !use_deoplete && has('lua')

if use_deoplete
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-jedi', { 'for': 'python' }
elseif use_neocomplete
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
au FileType text setlocal foldmethod=marker

" Update buffer when a file changes outside of vim
set autoread
au CursorHold,CursorHoldI * checktime

" Use comma for mapleader
" NOTE: set before defining mappings that use <leader>
let mapleader=","

let loaded_matchparen = 1  " prevent loading matchparen

" Load matchit:  extended matching with '%' key
runtime macros/matchit.vim

" Use ~/.cache/vim/ for swap & backup files
silent! call mkdir(expand('~/.cache/vim/swap', 'p'))
silent! call mkdir(expand('~/.cache/vim/backup', 'p'))
set directory^=~/.cache/vim/swap//
set backupdir^=~/.cache/vim/backup//
if ! has("nvim")
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
augroup filetypedetect

    " These filetypes map to other types
    au BufNewFile,BufRead *.thtml,*.ctp set filetype=php
    au BufNewFile,BufRead *.wsgi set filetype=python
    au BufNewFile,BufRead  Vagrantfile set filetype=ruby
    au BufNewFile,BufRead *.conf set filetype=conf
    au BufNewFile,BufRead requirements.txt,requirements_*.txt set filetype=conf
    au BufNewFile,BufRead *.ejs set filetype=html
    au BufNewFile,BufRead .eslintrc,.babelrc set filetype=javascript

    " Removes default django template detection in $VIMRUNTIME/filetype.vim
    au! BufNewFile,BufRead *.html,*.htm

    " Better django template detection
    " - looks for a few additional Django tag types.
    au BufNewFile,BufRead,BufWrite *.html,*.htm  call FThtml()
augroup END

" Distinguish between HTML, XHTML and Django
" custom/improved version than in runtime/filetype.vim
func! FThtml()
    let n = 1
    while n < 10 && n <= line("$")
      if getline(n) =~ '\<DTD\s\+XHTML\s'
        setf xhtml
        return
      endif
      if getline(n) =~ '{%\s*\(extends\|block\|load\|comment\|if\|for\)\>\|{#\s\+'
        setf htmldjango
        return
      endif
      let n = n + 1
    endwhile
    setf html
endfunc

" Files to use closetag plugin
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.jsx"

" Disable conceal feature in json files (vim-json)
let g:vim_json_syntax_conceal = 0

" Support jsx syntax in .js files (vim-jsx)
let g:jsx_ext_required = 0

" pangloss vim-javascript
let g:javascript_plugin_flow = 1

" Keyboard --------------------------------------------------------------- {{{1

" key sequence timeouts
set timeout timeoutlen=500 ttimeoutlen=50

" Allow terminal vim to recognize Alt key combos
" see: https://stackoverflow.com/questions/6778961/
if ! has("gui_running") && ! has("nvim")
    let c='a'
    while c <= 'z'
        exec "set <A-".c.">=\e".c
        exec "imap \e".c." <A-".c.">"
        let c = nr2char(1+char2nr(c))
    endw
endif

" Allow terminal vim to recognize XTerm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
if &term =~ "^screen"
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
if has("mouse")
    set mouse=a

    " Force sgr style mouse handling when in tmux.
    " This works fine with gnome-terminal & tmux combo. It should be
    " compatible with xterm too, but not sure what other terminals support it.
    if ! has("nvim") && &term =~ "^screen-256color"
        set ttymouse=sgr
    endif
endif

" Use system clipboard for yank/paste
if has("unnamedplus") || has("nvim")
    set clipboard=unnamedplus
endif

" pipe cursor in insert-mode, block in normal-mode
if has('nvim')
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
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
    if &background == 'dark'
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
    autocmd ColorScheme lucius call PatchLucius()
    colorscheme lucius
endif

" Colorizer mappings
" <leader>cC <Plug>Colorizer
" <leader>cT <Plug>ColorContrast
" <leader>cF <Plug>ColorFgBg
let g:colorizer_auto_map = 1


" Airline ---------------------------------------------------------------- {{{1
if ! has("gui_running")
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
        if g:airline_theme == 'lucius' && &background == 'dark'
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

noremap <silent> <f12> :call ToggleVExplorer()<CR>


" Neomake ---------------------------------------------------------------- {{{1

" check on save
autocmd! BufWritePost * :Neomake
autocmd! VimLeave * let g:neomake_verbose = 0
let g:neomake_verbose = 1

" makers
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_args = ["--ignore=E12"]
let g:neomake_vim_vint_args = ['-e', '--enable-neovim']

" customize error sign color
let g:neomake_error_sign = {'texthl': 'ErrorMsg'}
let g:neomake_warning_sign = {'texthl': 'WarningMsg'}


" NeoComplete ------------------------------------------------------------ {{{1
if use_neocomplete
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
if use_deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#enable_camel_case = 1

    " disable jedi completions since deoplete is used
    let g:jedi#completions_enabled = 0

    let g:deoplete#omni#input_patterns = {}
    let g:deoplete#omni#input_patterns.javascript = ['[^. \t0-9]\.([a-zA-Z_]\w*)?']

    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
endif

" UltiSnips -------------------------------------------------------------- {{{1
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsSnippetDirectories = ["UltiSnips"]
let g:UltiSnipsEditSplit = "vertical"


" UndoTree --------------------------------------------------------------- {{{1
" requires vim >= 7.3
if v:version >= 703
    nnoremap <F5> :UndotreeToggle<CR>
    let g:undotree_SplitWidth = 44
    let g:undotree_TreeNodeShape  = 'o'
endif


" FZF -------------------------------------------------------------------- {{{1
" If fzf is installed (.fzf  directory exists)
if isdirectory(expand('~/.fzf'))
    let g:fzf_is_installed = 1

    " loads fzf prograam as vim plugin
    set rtp+=~/.fzf

    " Use ag if available as default fzf command
    if executable('ag')
        let $FZF_DEFAULT_COMMAND = 'ag -g ""
                    \ --nogroup
                    \ --follow
                    \ --depth 50
                    \ --ignore .git/'
    endif

    " Customize fzf defaults
    let $FZF_DEFAULT_OPTS="
                \ --exact
                \ --tiebreak=length
                \ --inline-info
                \ --cycle
                \ --bind=tab:toggle-up,btab:toggle-down,alt-a:toggle-all
                \ --toggle-sort=ctrl-r"


    " Finds the git project root
    function! s:find_git_root()
        if executable('git')
            return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
        else
            return ''
        endif
    endfunction

    " Same as :Files command but use project root when inside git repo
    function! s:fzf_projectfiles()
        let s:extra_opts = ''
        let s:search_root = s:find_git_root()
        if s:search_root != ''
            let s:extra_opts = ' --hidden'
        endif
        return fzf#vim#files(s:search_root, {
                    \ 'source': $FZF_DEFAULT_COMMAND . s:extra_opts,
                    \ 'down': '~40%'
                    \ })
    endfunction

    command! -bang -nargs=? -complete=dir ProjectFiles call s:fzf_projectfiles()

    " Ag command with prompt for search pattern
    command! AgPrompt exec ":Ag " . input('Pattern: ')

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
    echo "Goyo Enter"
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
    echo "Goyo Leave"
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()


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
    autocmd! FileTYpe fzf call <SID>unset_tmux_maps_for_fzf()
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
if has("gui_running")
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
if has("gui_running")
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
    au!
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
        let textWidth = (&textwidth ? &textwidth : 79) + 1
        if &colorcolumn != ''
            setlocal colorcolumn&
        else
            let &l:colorcolumn=textWidth
        endif
    endfunction

    nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>
endif

" Displays the syntax highlighting group for word under cursor
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nnoremap <leader>sy :call <SID>SynStack()<CR>

" vim:foldmethod=marker:foldlevel=0
