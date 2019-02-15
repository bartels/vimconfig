" Vim syntax file
"
" This is a minimal syntax for adding typescript related syntax to javascript.
" It requires you to have an existing javascript syntax enabled.
" pangloss/vim-javascript is recommended and tested against.
"
" This has been modified from leafgarland/typescript-vim

syntax case match

" Overrides
syntax keyword jsNumber NaN

" typescript syntax
syntax keyword typescriptLabel readonly

" types
syntax keyword typescriptReserved constructor declare as interface module abstract enum int short default interface static byte extends long super char final native synchronized class float package throws goto private transient debugger implements protected volatile double public type namespace from get set keyof

syntax keyword typescriptExport export skipwhite skipempty

syntax match typescriptFunction "(super\s*|constructor\s*)" contained nextgroup=typescriptVars

syntax region typescriptVars start="(" end=")" contained contains=typescriptParameters transparent keepend

syntax match typescriptParameters "([a-zA-Z0-9_?.$][\w?.$]*)\s*:\s*([a-zA-Z0-9_?.$][\w?.$]*)" contained skipwhite

syntax keyword typescriptType DOMImplementation DocumentFragment Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction void any string boolean number symbol never object unknown

"" Code blocks
syntax cluster typescriptAll contains=typescriptLabel,typescriptType,typescriptReserved

syntax match typescriptBraces "[{}\[\]]"
syntax match typescriptParens "[()]"
syntax match typescriptOpSymbols "=\{1,3}\|!==\|!=\|<\|>\|>=\|<=\|++\|+=\|--\|-="
syntax match typescriptEndColons "[;,]"
syntax match typescriptLogicSymbols "\(&&\)\|\(||\)"

" Define the default highlighting.
command -nargs=+ HiLink hi def link <args>

"typescript highlighting
HiLink typescriptParameters Operator
HiLink typescriptEndColons Exception
HiLink typescriptOpSymbols Operator
HiLink typescriptLogicSymbols Boolean
HiLink typescriptBraces Noise
HiLink typescriptParens Noise
HiLink typescriptExport Include
HiLink typescriptInterpolationDelimiter Delimiter
HiLink typescriptReserved Keyword
HiLink typescriptType Type
HiLink typescriptLabel Label

delcommand HiLink

" Overrides
hi link jsBlockLabel Normal

" Define the htmltypescript for HTML syntax html.vim
syntax cluster htmltypescript contains=@typescriptAll,typescriptBracket,typescriptParen,typescriptBlock,typescriptParenError
syntax cluster typescriptExpression contains=@typescriptAll,typescriptBracket,typescriptParen,typescriptBlock,typescriptParenError,@htmlPreproc

" let b:current_syntax = 'typescript'
