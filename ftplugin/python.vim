"setlocal omnifunc=pythoncomplete#Complete

" python-mode settings
let g:pymode_lint = 0 " Turn off pylint since we're using syntastic
let g:pymode_folding = 0
let g:python_highlight_space_errors = 0


" Highlight lines over 80 chars
match LineNr /\%80v.\+/

" Highlight end of line whitespace.
2match LineNr /\s\+\%#\@<!$/
