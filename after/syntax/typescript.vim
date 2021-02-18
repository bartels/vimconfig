" highlight overrides
hi link typescriptImport Include
hi link typescriptImportType Include
hi link typescriptExport Include
hi link typescriptExportType Include
hi link typescriptVariable Type

" The following is in the latest vim and can be removed when nvim catches up
" https://github.com/neovim/neovim/issues/13410
" https://github.com/neovim/neovim/issues/13135

" add nullish coalescing operator - ??
" syntax match   typescriptBinaryOp contained /??/ nextgroup=@typescriptValue skipwhite skipempty

" type import (taken from yats.vim)
" syntax keyword typescriptImport                from as
" syntax keyword typescriptImport                import
"     \ nextgroup=typescriptImportType
"     \ skipwhite
" syntax keyword typescriptImportType            type
"     \ contained

" type export (taken from yats.vim)
" syntax keyword typescriptExport                export
"     \ nextgroup=typescriptExportType
"     \ skipwhite
" syntax match typescriptExportType              /\<type\s*{\@=/
"     \ contained skipwhite skipempty skipnl
