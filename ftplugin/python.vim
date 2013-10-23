"setlocal omnifunc=pythoncomplete#Complete
setlocal omnifunc=jedi#complete

" jedi-vim
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_function_definition = 1
let g:jedi#popup_select_first = 0

" Inserting breakpoints (this code was borrowed from python-mode plugin)
if has('python')
python << EOF
from imp import find_module
try:
    find_module('ipdb')
    vim.command('let g:python_breakpoint_cmd = "import ipdb; ipdb.set_trace() ### XXX BREAKPOINT"')
except ImportError:
    vim.command('let g:python_breakpoint_cmd = "import pdb; pdb.set_trace() ### XXX BREAKPOINT"')
EOF

fun! python:breakpoint_Set(lnum)
    let line = getline(a:lnum)
    if strridx(line, g:python_breakpoint_cmd) != -1
        normal dd
    else
        let plnum = prevnonblank(a:lnum)
        call append(line('.')-1, repeat(' ', indent(plnum)).g:python_breakpoint_cmd)
        normal k
    endif
endfunction

nnoremap <silent> <buffer> <leader>b :call python:breakpoint_Set(line('.'))<CR>
endif

" Highlight lines over 80 chars
" match LineNr /\%80v.\+/
" Highlight end of line whitespace.
2match LineNr /\s\+\%#\@<!$/
