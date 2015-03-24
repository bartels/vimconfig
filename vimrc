" Use pathogen for plugins
" Plugins are installed using 'git submodule', under ~/.vim/bundle/

" By default, pathogen will try to load all plugins, so selectively disable
" some if features are not available, makes this vimrc more useful on systems
" that lack features such as python or lua support.
let g:pathogen_disabled = []

" These plugins require python support
if !has('python')
    call add(g:pathogen_disabled, 'ultisnips')
    call add(g:pathogen_disabled, 'jedi')
endif

" These plugins require lua support
if !has('lua')
    call add(g:pathogen_disabled, 'neocomplete')
endif

" init pathogen
execute pathogen#infect()

" Some nice defaults
set number                      " show line numbers
set title                       " title in terminal window
set hidden                      " allow hiding buffers without a disk write
set incsearch hlsearch          " highlight the current search term
set scrolloff=3                 " number of context lines while scrolling
set sidescrolloff=3             " number of context columns
set laststatus=2                " always show the statusline
set backspace=indent,eol,start	" more powerful backspacing
set fileformats+=mac            " add 'mac' style EOLs
set display+=lastline           " always show as much of last line as possible
set history=1000                " command history entries
set tabpagemax=50               " increase max tabpages

" key sequence timeouts
set timeout timeoutlen=500 ttimeoutlen=50

" Enhanced command line completion options
set wildmenu
set wildmode=longest,list
set wildignore=*~,*.bak,*.o,*.pyc,*.pyo

" Insert mode completion
set completeopt=menuone,longest,preview

let loaded_matchparen = 1   " Turns off matchparen which I find annoying

" spaces, not tabs
set tabstop=8
set shiftwidth=4
set shiftround
set softtabstop=4
set expandtab
set smarttab

" clipboard integration
if has("unnamedplus") || has("nvim")
    set clipboard=unnamedplus
endif

" Turn on syntax and filetype detection
syntax on
filetype plugin indent on
set autoindent

" Special filetypes
" These are filetypes which should be recognized as another type.
augroup filetypedetect
  au BufNewFile,BufRead *.thtml,*.ctp set filetype=php
  au BufNewFile,BufRead *.wsgi set filetype=python
  au BufNewFile,BufRead  Vagrantfile set filetype=ruby
  au BufNewFile,BufRead *.conf set filetype=conf
  au BufNewFile,BufRead requirements.txt,requirements_*.txt set filetype=conf
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

" This will update the buffer when file changes outside of vim
set autoread
au CursorHold,CursorHoldI * checktime

" Use ~/.cache/vim/ for swap & backup files
silent! call mkdir(expand('~/.cache/vim/swap', 'p'))
silent! call mkdir(expand('~/.cache/vim/backup', 'p'))
set directory^=~/.cache/vim/swap//
set backupdir^=~/.cache/vim/backup//
set viminfo+=n~/.cache/vim/viminfo

" Color Theme
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

" airline - enhanced status line plugin
if ! has("gui_running")
    let g:airline_powerline_fonts=1
    let g:airline_right_sep=''

    " tabline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#tab_min_count = 2
    let g:airline#extensions#tabline#show_tab_type = 0
    let g:airline#extensions#tabline#show_buffers = 0
    let g:airline#extensions#tabline#fnamemod = ':t'

    " customize some theme colors
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

" Mouse support
if has("mouse")
    set mouse=a

    " Force sgr style mouse handling when in tmux.
    " Setting this works fine with gnome-terminal/tmux combo. It should be
    " compatible with xterm too, but not sure what other terminals support it.
    if &term =~ "^screen-256color"
        set ttymouse=sgr
    endif
endif

" Folding
set foldmethod=manual
au FileType text setlocal foldmethod=marker

" Change the mapleader from \ to ,
let mapleader=","

" View for invisible chars when using set list
set listchars=tab:▸\ ,eol:¬
nnoremap <leader>l :set list!<CR>

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

noremap <silent> <f12> :call ToggleVExplorer()<CR>

let g:vim_json_syntax_conceal = 0


"""""""""""""""""
" Plugin Settings
"""""""""""""""""

" Syntastic
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_auto_jump = 0
let g:syntastic_auto_loc_list = 2
let g:syntastic_python_flake8_args='--ignore=E12'
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_json_checkers = ['jsonlint']
nnoremap <leader>e :SyntasticToggleMode<CR>


" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 0
let g:neocomplete#data_directory = '~/.cache/vim/neocomplete'

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '[^. \t]\.\w*\|from \w\+\s\+import \w'
let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'

" Tab completion in menus
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


" UltiSnips
let g:UltiSnipsExpandTrigger = "<c-j>"
"let g:UltiSnipsListSnippets = "<c-j>"
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "snippets"]
let g:UltiSnipsEditSplit = "vertical"

" undotree (only works with vim >= 7.3)
if v:version >= 703
    nnoremap <F5> :UndotreeToggle<CR>
endif
let g:undotree_SplitWidth = 44
let g:undotree_TreeNodeShape  = 'o'

" Unite.vim
let g:unite_winheight = 25
let g:unite_split_rule = 'botright'
let g:unite_force_overwrite_statusline = 0
let g:unite_source_history_yank_enable = 1
let g:unite_enable_smart_case = 1
let g:unite_source_rec_max_cache_files = 5000
let g:unite_data_directory = '~/.cache/vim/unite'

" Use 'ag' for unite grep if available
if executable('ag')
    let g:unite_source_rec_async_command = 'ag -l .'
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column
                \ --ignore dist/
                \ --ignore bower_components/
                \ --ignore node_modules/
                \ --ignore coverage/
                \ --ignore .coverage/
                \ --ignore htmlcov/'
    let g:unite_source_grep_recursive_opt = ''
end

" Configure to sort by length
silent! call unite#custom#source(
            \ 'buffer,file,file_mru,file_rec,file_rec/async',
            \ 'sorters', ['sorter_length'])

" Shortcut for calling unite commands
function! UniteCmd(action, ...)
    if a:0 > 0
        let args = a:1
    else
        let args = ''
    endif

    let name = split(a:action)[0]

    return ":\<C-u>Unite ".a:action." -buffer-name=".name.' '.args."\<CR>"
endfunction

" Set up key mappings to start Unite actions
nnoremap <silent><expr><leader>f UniteCmd('file'             . (expand('%') == '' ? '' : ':%:h') .
                                        \' file_rec/async:!' . (expand('%') == '' ? '' : ':%:h'),
                                         \'-start-insert')
nnoremap <silent><expr><leader>b UniteCmd('buffer', '-start-insert')
nnoremap <silent><expr><leader>a UniteCmd('grep:.')
nnoremap <silent><expr><leader>y UniteCmd('history/yank')
nnoremap <silent><expr><leader>u UniteCmd('ultisnips')
nnoremap <silent><expr><leader>o UniteCmd('outline')
nnoremap <silent><expr><leader>h UniteCmd('help', '-start-insert')
nnoremap <silent><expr><leader>r UniteCmd('file_mru', '-start-insert')

" Custom mappings when inside Unite buffers
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


" Surround
let g:surround_no_insert_mappings = 1   " turn off insert mode mappings


" goyo (for distraction free writing)
noremap <leader>` :Goyo<CR>

" Custom settings when in goyo mode
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

" Restore settings when leaving goyo mode
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


" instant-markdown
" Don't autostart, run :InstantMarkdownPreview to start it
let g:instant_markdown_autostart = 0


"""""""""""""""""
" Custom Mappings
"""""""""""""""""

" Make vim recognize Alt key in terminals that send an escape sequence
" see: https://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim
if ! has("gui_running")
    let c='a'
    while c <= 'z'
        exec "set <A-".c.">=\e".c
        exec "imap \e".c." <A-".c.">"
        let c = nr2char(1+char2nr(c))
    endw
endif

" Make Vim recognize XTerm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
if &term =~ "^screen"
    " Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
    execute "set t_kP=\e[5;*~"
    execute "set t_kN=\e[6;*~"

    " Arrow keys http://unix.stackexchange.com/a/34723
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Prevent jumping back one char when leaving insert mode
inoremap <Esc> <Esc>`^

" Escape insert mode with kj
imap kj <Esc>

" C-g => C-c (I've been playing with emacs evil-mode)
noremap <C-g> <C-c>
inoremap <C-g> <C-c>
cnoremap <C-g> <C-c>


" Some familiar editing bindings
" These do not work in terminal vim
if has("gui_running")
    inoremap <C-DEL> <C-O>dw
    inoremap <C-BACKSPACE> <C-W>
    inoremap <C-Enter> <C-o>o
    inoremap <C-S-Enter> <C-o>O
endif

" Easier way to jump to the beginning/end of the line
nnoremap <S-H> ^
nnoremap <S-L> $

" Save file with sudo
" This is for when you accidentally open a file and realize you need to sudo
" in order to save your changes.  Just run :w!!
cnoremap w!! w !sudo tee % > /dev/null

" Clear last search (to clear our current highlighted search terms)
nnoremap <leader><space> :noh<CR>

" Keyboard navaigation between windows
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k

" Use C-Space as omnicomplete shortcut
inoremap <C-Space> <C-x><C-o>

" Custom mappings for dealing with tabpages
nnoremap <silent> <leader>t :tabnew<CR>
nnoremap <silent> <leader>w :close<CR>
noremap <A-j> gt
noremap <A-k> gT
inoremap <A-j> <ESC>gt
inoremap <A-k> <ESC>gT

" Familiar bindings - these ones do not work in terminal
if has("gui_running")
    noremap <C-TAB> gt
    noremap <C-S-TAB> gT
    noremap <S-A-j> gt
    noremap <S-A-k> gT
    inoremap <S-A-j> <ESC>gt
    inoremap <S-A-k> <ESC>gT
endif

" Mappings for creating window splits
nnoremap <silent> <leader>v :vsplit<CR>
nnoremap <silent> <leader>s :split<CR>

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

" Shows the syntax highlighting group for word under cursor
" This is useful if you're interested in figuring out how the current word is
" being highlighted by color themes.
nnoremap <leader>sy :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Open up vimrc file
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
" Source the vimrc file
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>
