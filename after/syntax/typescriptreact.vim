runtime! after/syntax/typescript.vim

" highlight overrides
hi link tsxTagName htmlTagName
hi link tsxAttrib htmlArg

hi link jsxComponentName htmlTagName
hi link jsxAttrib htmlArg

hi link htmlTagName Statement
hi link htmlArg Type

" styled-components
" Hack to get typescriptComments cluster into styledDefinition region
syntax cluster CSSTop add=@typescriptComments
