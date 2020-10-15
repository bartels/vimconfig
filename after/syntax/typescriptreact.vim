runtime! after/syntax/typescript.vim

" highlight overrides
hi link tsxTagName htmlTagName
hi link htmlTagName Statement

" styled-components
" Hack to get typescriptComments cluster into styledDefinition region
syntax cluster CSSTop add=@typescriptComments
