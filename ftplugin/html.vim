setlocal omnifunc=htmlcomplete#CompleteTags

" Fix problem with wrong highlighting in some js files. This will force vim to
" sync highlighting from start of file
syntax sync fromstart

" Html comments for auto-pairs
let b:AutoPairs = AutoPairsDefine({'<!--': '-->'})
