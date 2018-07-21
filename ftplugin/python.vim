" Set python omnicomplete function
setlocal omnifunc=jedi#completions
"setlocal omnifunc=pythoncomplete#Complete

" jedi-vim settings
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 1
let g:jedi#popup_select_first = 0
let g:jedi#use_tabs_not_buffers = 0

" Inserting breakpoints
" This code was borrowed from the python-mode plugin.
if has('python')
python << EOF
import vim
from imp import find_module
try:
    find_module('ipdb')
    pdb = 'ipdb'
except ImportError:
    pdb = 'pdb'
vim.command('let g:python_breakpoint_cmd = "import {0}; {0}.set_trace() ### XXX BREAKPOINT"'.format(pdb))
EOF

    fun! BreakpointSet(lnum)
        let l:line = getline(a:lnum)
        if strridx(l:line, g:python_breakpoint_cmd) != -1
            normal! dd
        else
            let l:plnum = prevnonblank(a:lnum)
            call append(line('.')-1, repeat(' ', indent(l:plnum)).g:python_breakpoint_cmd)
            normal! k
        endif
    endfunction

    nnoremap <silent> <buffer> <leader>p :call BreakpointSet(line('.'))<CR>
endif

" language server mappings
call LanguageServerMaps()
