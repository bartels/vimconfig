
" highlight overrides
hi link typescriptImport Include
hi link typescriptImportType Include
hi link typescriptExport Include
hi link typescriptExportType Include
hi link typescriptVariable Type

" styled-components
" Hack to get typescriptComments cluster into styledDefinition region
syntax cluster CSSTop add=@typescriptComments

" add optional chaining syntax - ?.
syntax match   typescriptDotNotation           /\.\|?\.\|!\./ nextgroup=typescriptProp skipnl

" add nullish coalescing operator - ??
syntax match   typescriptBinaryOp contained /??/ nextgroup=@typescriptValue skipwhite skipempty

" Fix ternary operator, distinct from .? and ?? operators
syntax region typescriptTernary matchgroup=typescriptTernaryOp start=/?[.?]\@!/ end=/:/ contained contains=@typescriptValue,@typescriptComments nextgroup=@typescriptValue skipwhite skipempty

" type import (taken from yats.vim)
syntax keyword typescriptImport                from as
syntax keyword typescriptImport                import
    \ nextgroup=typescriptImportType
    \ skipwhite
syntax keyword typescriptImportType            type
    \ contained

" type export (taken from yats.vim)
syntax keyword typescriptExport                export
    \ nextgroup=typescriptExportType
    \ skipwhite
syntax match typescriptExportType              /\<type\s*{\@=/
    \ contained skipwhite skipempty skipnl


" JSX syntax
" Below is copied and modified from plugin: neoclide/vim-jsx-improve
let s:jsx_cpo = &cpo
set cpo&vim

syntax case match

if exists('b:current_syntax')
  let s:current_syntax = b:current_syntax
  unlet b:current_syntax
endif

if exists('s:current_syntax')
  let b:current_syntax = s:current_syntax
endif

" <tag id="sample">
" s~~~~~~~~~~~~~~~e
syntax region jsxTag
      \ matchgroup=jsxTag start=+<[^ }/!?<"'=:]\@=+
      \ matchgroup=jsxTag end=+\/\?>+
      \ contained
      \ contains=jsxTagName,jsxComponentName,jsxAttrib,jsxEqual,jsxString,jsxEscapeJsAttributes,

" </tag>
" ~~~~~~
syntax match jsxEndTag
      \ +</[^ /!?<>"']*>+
      \ contained
      \ contains=jsxEndString,jsxEndComponentName


"  <tag/>
" s~~~~~~e
syntax match jsxSelfClosingTag +<[^ /!?<>"'=:]\+\%(\%(=>\|[>]\@!\_.\)\)\{-}\/>+
      \ contained
      \ contains=jsxTag,@Spell
      \ transparent


"  <tag></tag>
" s~~~~~~~~~~~e
syntax region jsxRegion
      \ start=+<\z([^ /!?<>"'=:]\+\)+
      \ start=+<\z(\s\{0}\)>+
      \ skip=+<!--\_.\{-}-->+
      \ end=+</\z1\_s\{-}>+
      \ end=+/>+
      \ fold
      \ contains=jsxSelfClosingTag,jsxRegion,jsxTag,jsxEndTag,jsxComment,jsxEntity,jsxEscapeJsContent,@Spell
      \ keepend
      \ extend

syntax match jsxEndString
    \ +\w\++
    \ contained

" <!-- -->
" ~~~~~~~~
syntax match jsxComment /<!--\_.\{-}-->/ display

syntax match jsxEntity "&[^; \t]*;" contains=jsxEntityPunct
syntax match jsxEntityPunct contained "[&.;]"

" <tag key={this.props.key}>
"  ~~~
syntax match jsxTagName
    \ +[<]\@<=[^ /!?<>"']\++
    \ contained
    \ display

" <MyComponent ...>
"  ~~~~~~~~~~~
" NOT
" <someCamel ...>
"      ~~~~~
syntax match jsxComponentName
    \ +\<[A-Z][\$0-9A-Za-z]\+\>+
    \ contained
    \ display 

" </MyComponent ...>
"   ~~~~~~~~~~~
syntax match jsxEndComponentName
    \ +[A-Z][\$0-9A-Za-z]\++
    \ contained

" <tag key={this.props.key}>
"      ~~~
syntax match jsxAttrib
    \ +[-'"<]\@<!\<[a-zA-Z:_][-.0-9a-zA-Z0-9:_]*\>\(['">]\@!\|\>\|$\)+
    \ contained
    \ contains=jsxAttribPunct,jsxAttribHook
    \ display

syntax match jsxAttribPunct +[:.]+ contained display

" <tag id="sample">
"        ~
syntax match jsxEqual +=+ contained display

" <tag id="sample">
"         s~~~~~~e
syntax region jsxString contained start=+"+ end=+"+ contains=jsxEntity,@Spell display

" <tag id='sample'>
"         s~~~~~~e
syntax region jsxString contained start=+'+ end=+'+ contains=jsxEntity,@Spell display

" <tag key={this.props.key}>
"          s~~~~~~~~~~~~~~e
syntax region jsxEscapeJsAttributes
    \ matchgroup=jsxAttributeBraces start=+{+
    \ matchgroup=jsxAttributeBraces end=+}\ze\%(\/\|\n\|\s\|<\|>\)+
    \ contained
    \ contains=TOP,jsBlock
    \ keepend
    \ extend

" <tag>{content}</tag>
"      s~~~~~~~e
syntax region jsxEscapeJsContent
    \ matchgroup=jsxAttributeBraces start=+{+
    \ matchgroup=jsxAttributeBraces end=+}+
    \ contained
    \ contains=TOP
    \ keepend
    \ extend

syntax match jsxIfOperator +?+
syntax match jsxElseOperator +:+

syntax cluster typescriptExpression add=jsxRegion,jsxSelfClosingTag

highlight def link jsxString String
highlight def link jsxNameSpace Function
highlight def link jsxComment Error
highlight def link jsxEscapeJsAttributes jsxEscapeJsAttributes

if hlexists('htmlTag')
  highlight def link jsxTagName htmlTagName
  highlight def link jsxComponentName htmlTagName
  highlight def link jsxEndComponentName htmlTagName
  highlight def link jsxEqual htmlTag
  highlight def link jsxAttrib htmlArg
  highlight def link jsxTag htmlTag
  highlight def link jsxEndTag htmlTag
  highlight def link jsxEndString htmlTagName
  highlight def link jsxAttributeBraces htmlTag
else
  highlight def link jsxTagName Statement
  highlight def link jsxComponentName Statement
  highlight def link jsxEndComponentName Statement
  highlight def link jsxEndString Statement
  highlight def link jsxEqual Function
  highlight def link jsxTag Function
  highlight def link jsxEndTag Function
  highlight def link jsxAttrib Type
  highlight def link jsxAttributeBraces Special
endif

let b:current_syntax = 'typescript'

if &ft == 'html'
  syn region  htmlScriptTag     contained start=+<script+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent
endif

let &cpo = s:jsx_cpo
unlet s:jsx_cpo
