" Vim syntax file
"
" This is a minimal syntax for adding typescript related syntax to javascript.
" It requires you to have an existing javascript syntax enabled.
" pangloss/vim-javascript is recommended and tested against.
"
" This has been modified from leafgarland/typescript-vim

syntax case match

"" Syntax in the typescript code"{{{
syntax match typescriptSpecial "\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}" contained containedin=typescriptStringD,typescriptStringS,typescriptStringB display
syntax region typescriptStringD start=+"+ skip=+\\\\\|\\"+ end=+"\|$+  contains=typescriptSpecial,@htmlPreproc extend
syntax region typescriptStringS start=+'+ skip=+\\\\\|\\'+ end=+'\|$+  contains=typescriptSpecial,@htmlPreproc extend
syntax region typescriptStringB start=+`+ skip=+\\\\\|\\`+ end=+`+  contains=typescriptInterpolation,typescriptSpecial,@htmlPreproc extend

syntax region typescriptInterpolation matchgroup=typescriptInterpolationDelimiter
      \ start=/${/ end=/}/ contained
      \ contains=@typescriptExpression

syntax match typescriptNumber "-\=\<\d[0-9_]*L\=\>" display
syntax match typescriptNumber "-\=\<0[xX][0-9a-fA-F][0-9a-fA-F_]*\>" display
syntax match typescriptNumber "-\=\<0[bB][01][01_]*\>" display
syntax match typescriptNumber "-\=\<0[oO]\o[0-7_]*\>" display
syntax region typescriptRegexpString start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gi]\{0,2\}\s*$+ end=+/[gi]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline
syntax match typescriptFloat /\<-\=\%(\d[0-9_]*\.\d[0-9_]*\|\d[0-9_]*\.\|\.\d[0-9]*\)\%([eE][+-]\=\d[0-9_]*\)\=\>/
"}}}

"" typescript Prototype"{{{
syntax keyword typescriptPrototype contained prototype
"}}}

"" Programm Keywords"{{{
syntax keyword typescriptDeprecated escape unescape all applets alinkColor bgColor fgColor linkColor vlinkColor xmlEncoding
"}}}

"" Statement Keywords"{{{
syntax keyword typescriptLabel readonly

syntax keyword typescriptGlobalObjects Array Boolean Date Function Infinity Math Number NaN Object Packages RegExp String Symbol netscape

syntax keyword typescriptReserved constructor declare as interface module abstract enum int short export default interface static byte extends long super char final native synchronized class float package throws goto private transient debugger implements protected volatile double public type namespace from get set keyof

syntax keyword typescriptExport export skipwhite skipempty
"}}}

" typescript Objects"{{{
syntax match typescriptFunction "(super\s*|constructor\s*)" contained nextgroup=typescriptVars
syntax region typescriptVars start="(" end=")" contained contains=typescriptParameters transparent keepend
syntax match typescriptParameters "([a-zA-Z0-9_?.$][\w?.$]*)\s*:\s*([a-zA-Z0-9_?.$][\w?.$]*)" contained skipwhite
"}}}

syntax keyword typescriptType DOMImplementation DocumentFragment Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction void any string boolean number symbol never object unknown

"" Code blocks
syntax cluster typescriptAll contains=typescriptStringD,typescriptStringS,typescriptStringB,typescriptRegexpString,typescriptNumber,typescriptFloat,typescriptLabel,typescriptType,typescriptGlobalObjects,typescriptReserved,typescriptDeprecated

syntax sync clear

syntax match typescriptBraces "[{}\[\]]"
syntax match typescriptParens "[()]"
syntax match typescriptOpSymbols "=\{1,3}\|!==\|!=\|<\|>\|>=\|<=\|++\|+=\|--\|-="
syntax match typescriptEndColons "[;,]"
syntax match typescriptLogicSymbols "\(&&\)\|\(||\)"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if v:version >= 508 || !exists('did_typescript_syn_inits')
  if v:version < 508
    let did_typescript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  "typescript highlighting
  HiLink typescriptParameters Operator
  HiLink typescriptEndColons Exception
  HiLink typescriptOpSymbols Operator
  HiLink typescriptLogicSymbols Boolean
  HiLink typescriptBraces Function
  HiLink typescriptParens Operator
  HiLink typescriptExport Include
  HiLink typescriptStringS String
  HiLink typescriptStringD String
  HiLink typescriptStringB String
  HiLink typescriptInterpolationDelimiter Delimiter
  HiLink typescriptRegexpString String
  HiLink typescriptPrototype Type
  HiLink typescriptDeprecated Exception
  HiLink typescriptReserved Keyword
  HiLink typescriptType Type
  HiLink typescriptNumber Number
  HiLink typescriptFloat Number
  HiLink typescriptLabel Label
  HiLink typescriptSpecial Special
  HiLink typescriptGlobalObjects Special
  HiLink typescriptFuncComma Operator
  HiLink typescriptNumber Number

  delcommand HiLink
endif

" Define the htmltypescript for HTML syntax html.vim
syntax cluster htmltypescript contains=@typescriptAll,typescriptBracket,typescriptParen,typescriptBlock,typescriptParenError
syntax cluster typescriptExpression contains=@typescriptAll,typescriptBracket,typescriptParen,typescriptBlock,typescriptParenError,@htmlPreproc

let b:current_syntax = 'typescript'

" vim: ts=4
