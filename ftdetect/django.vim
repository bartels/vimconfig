" Remove default django template detection in $VIMRUNTIME/filetype.vim
autocmd! BufNewFile,BufRead *.html,*.htm

" Distinguish between HTML, XHTML and Django
" custom/improved version than in runtime/filetype.vim
func! FThtml()
    let l:n = 1
    while l:n < 10 && l:n <= line('$')
      if getline(l:n) =~# '\<DTD\s\+XHTML\s'
        setf xhtml
        return
      endif
      if getline(l:n) =~# '{%\s*\(extends\|block\|load\|comment\|if\|for\)\>\|{#\s\+'
        setf htmldjango.html
        return
      endif
      let l:n = l:n + 1
    endwhile
    setf html
endfunc


" Better django template detection
" - looks for a few additional Django tag types.
autocmd BufNewFile,BufRead,BufWrite *.html,*.htm call FThtml()
