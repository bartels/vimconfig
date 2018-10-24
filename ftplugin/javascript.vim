" Use 2 spaces for indentation
setlocal shiftwidth=2 softtabstop=2  expandtab

" There are errors indenting jsx code, so turning disabling re-indent
let b:surround_indent = 0

" Support jsx syntax in .js files (vim-jsx)
let g:jsx_ext_required = 0

" vim-javascript
let g:javascript_plugin_flow = 1

" language server mappings
call LanguageClientMaps()
