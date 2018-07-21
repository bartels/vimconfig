" Use 2 spaces for indentation
setlocal shiftwidth=2 softtabstop=2  expandtab

" Set javascript omnicomplete function
setlocal omnifunc=javascriptcomplete#CompleteJS

" vim-flow
nnoremap <silent><leader>d :FlowJumpToDef<CR>

" Fix problem with wrong highlighting in some js files. This will force vim to
" sync highlighting from start of file
syntax sync fromstart

" There are errors indenting jsx code, so turning disabling re-indent
let b:surround_indent = 0

" language server mappings
call LanguageServerMaps()
