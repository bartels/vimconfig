" maps
nnoremap <silent> <buffer> <nowait> q :bd<CR>
nnoremap <silent> <buffer> d <c-d>
nnoremap <silent> <buffer> u <c-u>
nnoremap <silent> <buffer> i <Nop>
nnoremap <silent> <buffer> I <Nop>
nnoremap <silent> <buffer> a <Nop>
nnoremap <silent> <buffer> A <Nop>
nnoremap <silent> <buffer> o <Nop>
nnoremap <silent> <buffer> O <Nop>

" Open help in vertical split
:wincmd H | :vert resize 90
autocmd! BufWinEnter <buffer> :wincmd H | :vert resize 90
