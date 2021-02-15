" Use 2 spaces for indentation
setlocal shiftwidth=2 softtabstop=2  expandtab

" There are errors indenting jsx code, so disabling re-indent
let b:surround_indent = 0

" commenting
let b:comment_char = '/'

" Coc formatting
nnoremap <silent><buffer><leader>gf :CocCommand eslint.executeAutofix .<CR>
