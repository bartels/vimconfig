" Load the xml.vim plugin (good for jsx completion)
runtime! ftplugin/xml.vim

" Use 2 spaces for indentation
setlocal shiftwidth=2 softtabstop=2  expandtab

" Set javascript omnicomplete function
setlocal omnifunc=javascriptcomplete#CompleteJS

" Fix problem with wrong highlighting in some js files. This will force vim to
" sync highlighting from start of file
syntax sync fromstart
