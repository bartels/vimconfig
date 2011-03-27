" Highlight lines over 80 chars
highlight OverLength ctermbg=black guibg=black
match OverLength /\%80v.\+/

" Highlight end of line whitespace.
highlight ExtraWhitespace ctermbg=red guibg=red
2match ExtraWhitespace /\s\+\%#\@<!$/
