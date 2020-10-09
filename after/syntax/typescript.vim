" highlight overrides
hi link typescriptImport Include
hi link typescriptImportType Include
hi link typescriptExport Include
hi link typescriptExportType Include
hi link typescriptVariable Type

" styled-components
" Hack to get typescriptComments cluster into styledDefinition region
syntax cluster CSSTop add=@typescriptComments

" add nullish coalescing operator - ??
syntax match   typescriptBinaryOp contained /??/ nextgroup=@typescriptValue skipwhite skipempty

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
