" Initialization --------------------------------------------------------- {{{1

" Use pathogen for plugins
" Plugins are installed using 'git submodule', under ~/.vim/bundle/

" Disable plugins if feature support is missing
let g:pathogen_disabled = []

" Plugins that require python
if !has('python')
    call add(g:pathogen_disabled, 'ultisnips')
    call add(g:pathogen_disabled, 'jedi')
endif

" Plugins that require lua
if !has('lua')
    call add(g:pathogen_disabled, 'neocomplete')
endif

" Plugins to ignore for nvim
if has('nvim')
    call add(g:pathogen_disabled, 'neocomplete')
    call add(g:pathogen_disabled, 'syntastic')
endif

" Plugins to ignore for regular vim
if !has('nvim')
    call add(g:pathogen_disabled, 'neomake')
endif

execute pathogen#infect()


" Misc ------------------------------------------------------------------- {{{1

set hidden                        " switch buffers without needing to save
set backspace=indent,eol,start    " more powerful backspacing
set fileformats+=mac              " handle 'mac' style EOLs
set history=1000                  " command history entries
set modeline                      " alow modlines in files

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


" Spaces & Tabs ---------------------------------------------------------- {{{1

set tabstop=4           " number of visual spaces per tab
set softtabstop=4       " number of spaces per tab when editing
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

    " Removes default django template detection in $VIMRUNTIME/filetype.vim
    au! BufNewFile,BufRead *.html,*.htm

    " Better django template detection
    " - looks for a few additional Django tag types.
    au BufNewFile,BufRead,BufWrite *.html,*.htm  call FThtml()
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

augroup END

" Disable conceal feature in json files
let g:vim_json_syntax_conceal = 0


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


" Colors & UI------------------------------------------------------------- {{{1

set title                         " title in terminal window
set number                        " show line numbers
set cursorline                    " highlight current line
set display+=lastline             " always show as much of last line of file
set laststatus=2                  " always show the statusline
set tabpagemax=50                 " increase max tabpages
set incsearch hlsearch            " highlight search terms as you type
set scrolloff=3                   " number of context lines while scrolling
set sidescrolloff=3               " number of context columns

" Colors
if has('gui_running')
    let g:solarized_menu=0
    call togglebg#map("<F6>")
    set background=light
    colorscheme solarized
    set guifont=DejaVu\ Sans\ Mono\ 9
else
    let g:solarized_termcolors=256
    set background=dark
    colorscheme lucius
    LuciusDark
endif

" Highlight cursorline number only (not entire line)
hi clear CursorLine
augroup CLClear
    autocmd! ColorScheme * hi clear CursorLine
augroup END

" Invisible chars to use with :set list
set listchars=tab:▸\ ,trail:·
set list

" Command line completion options
set wildmenu
set wildmode=longest,list
set wildignore=*~,*.bak,*.o,*.pyc,*.pyo

" Insert mode completion options
set completeopt=menuone,longest,preview

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


" Airline ---------------------------------------------------------------- {{{1
if ! has("gui_running")
    let g:airline_powerline_fonts=1
    let g:airline_right_sep=''

    " tabline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#tab_min_count = 2
    let g:airline#extensions#tabline#show_tab_type = 0
    let g:airline#extensions#tabline#show_buffers = 0
    let g:airline#extensions#tabline#fnamemod = ':t'

    " override some theme colors
    let g:airline_theme_patch_func = 'AirlineThemePatch'
    function! AirlineThemePatch(palette)
        if g:airline_theme == 'lucius'
            " make inactive split colors darker
            for colors in values(a:palette.inactive)
                let colors[2] = 242
                let colors[3] = 237
            endfor
            let a:palette.inactive['airline_c'][2] = 244
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


" Syntastic -------------------------------------------------------------- {{{1
if ! has("nvim")
    let g:syntastic_mode_map = { 'mode': 'passive' }
    let g:syntastic_auto_jump = 0
    let g:syntastic_auto_loc_list = 2
    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_python_flake8_args='--ignore=E12'
    let g:syntastic_javascript_checkers = ['eslint']
    let g:syntastic_yaml_checkers=['jsyaml']
    let g:syntastic_json_checkers = ['jsonlint']

    nnoremap <leader>e :SyntasticToggleMode<CR>
endif


" Neomake -------------------------------------------------------------- {{{1

if has("nvim")
    " check on save
    autocmd! BufWritePost * Neomake
    autocmd! QuitPre * let g:neomake_verbose = 0
    let g:neomake_verbose = 1

    " makers
    let g:neomake_javascript_enabled_makers = ['eslint']
    let g:neomake_python_enabled_makers = ['flake8']
    let g:neomake_python_flake8_args = ["--ignore=E12"]
    let g:neomake_vim_vint_args = ['-e', '--enable-neovim']


    " This is currently not working, no idea why
    " It will populate the location list but now signs and no way to jump to
    " the correct line
    let g:neomake_yaml_jsyaml_maker = {
                \ 'exe': 'js-yaml',
                \ 'errorformat':
                    \ 'Error on line %l\, col %c:%m,' .
                    \ 'JS-YAML: %m at line %l\, column %c:,' .
                    \ 'YAMLException: %m at line %l\, column %c:,' .
                    \ '%-G%.%#',
                \ }
    let g:neomake_yaml_enabled_makers = ['jsyaml']

    " customize error sign color
    let g:neomake_error_sign = {
        \ 'texthl': 'ErrorMsg',
        \ }
endif


" NeoComplete ------------------------------------------------------------ {{{1
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


" Unite ------------------------------------------------------------------ {{{1
let g:unite_force_overwrite_statusline = 0
let g:unite_source_history_yank_enable = 1
let g:unite_source_rec_max_cache_files = 5000
let g:unite_data_directory = '~/.cache/vim/unite'

" options controlling unite window
call unite#custom#profile('default', 'context', {
\  'winheight': 25,
\  'direction': 'botright',
\  'cursor_line_time': '0.0',
\  'prompt_direction': 'below'
\  })

" buffer specific options
call unite#custom#profile('file,file_mru,file_rec,file_rec/async,buffer,help', 'context', {
\  'start_insert': 1
\  })

" Use 'ag' for unite grep if available
" This is much faster, as ag will take into account the repo (git,hg, etc)
if executable('ag')
    let g:unite_source_rec_async_command = 'ag -l --nocolor --nogroup --hidden .'
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column
                \ --ignore dist/
                \ --ignore bundles/
                \ --ignore bower_components/
                \ --ignore node_modules/
                \ --ignore coverage/
                \ --ignore .coverage/
                \ --ignore htmlcov/'
    let g:unite_source_grep_recursive_opt = ''
end

" Use length sorter for file searches
call unite#custom#source(
            \ 'buffer,file,file_rec,file_rec/async',
            \ 'sorters', ['sorter_length'])

" Shortcut function for calling unite commands
function! UniteCmd(action, ...)
    if a:0 > 0
        let args = a:1
    else
        let args = ''
    endif

    let name = split(a:action, ':')[0]

    return ":\<C-u>Unite ".a:action." -buffer-name=".name.' '.args."\<CR>"
endfunction

" Unite mappings
nnoremap <silent><expr><leader>f UniteCmd('file_rec/async:! file')
nnoremap <silent><expr><leader>b UniteCmd('buffer')
nnoremap <silent><expr><leader>a UniteCmd('grep:.')
nnoremap <silent><expr><leader>y UniteCmd('history/yank')
nnoremap <silent><expr><leader>u UniteCmd('ultisnips')
nnoremap <silent><expr><leader>o UniteCmd('outline')
nnoremap <silent><expr><leader>h UniteCmd('help')
nnoremap <silent><expr><leader>rf UniteCmd('file_mru')

" Unite buffer mappings
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

    nmap <silent><buffer><expr> v unite#do_action('vsplit')
    nmap <silent><buffer><expr> s unite#do_action('split')
    nmap <silent><buffer><expr> x unite#do_action('split')

    " navigation
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction


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
    echo "Goyo Leave"
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()


" Instant Markdown ------------------------------------------------------- {{{1
" Don't autostart, run :InstantMarkdownPreview to open preview
let g:instant_markdown_autostart = 0


" Key Mappings ----------------------------------------------------------- {{{1

" Prevent jumping back one char when leaving insert mode
inoremap <Esc> <Esc>`^

" Use kj for escape
imap kj <Esc>

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

" Navigate between vim windows
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k

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
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>

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
