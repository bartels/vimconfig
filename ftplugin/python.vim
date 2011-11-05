" Highlight lines over 80 chars
match LineNr /\%80v.\+/

" Highlight end of line whitespace.
2match LineNr /\s\+\%#\@<!$/
