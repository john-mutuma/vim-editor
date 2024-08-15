" set this as a symbolic link in .vim/plugin

fun! s:SetCustomJavaScriptSyntaxHighlights()
  " syntax match jsOperators               /\v[^+-/*][+-/*][^+-/*]/
  syntax match jsNot                     /\v!/
  syntax match jsTernaries               /\v[:?]/
  syntax match jsEllipsis                /\v\.\.\./
  syntax match   jsFuncCall              /\<\K\k*\ze\s*(/
  syntax match typescriptVariableKeyword /\v\sconst\s/
  syntax match dotNotation               /\v[ \.\<]\zs[a-zA-Z0-9_]+\ze\./
  syntax match jsDot                     /\v\./
  syntax keyword javaScriptArrayMethods     map, filter, reduce, forEach, join, sort, push, reduceRight, pop, find, concat, reverse, shift, slice, toString, includes, keys, splice, const, let, null
  syntax keyword typescriptFuncKeyword function

  highlight link jsNot                       SpecialChar
  highlight link javaScriptArrayMethods      Keyword
  highlight link jsEllipsis                  SpecialChar
  highlight link jsTernaries                 SpecialChar
  highlight link jsParens                    SpecialChar
  highlight link jsFuncCall                  Function
  highlight link jsDot                       SpecialChar
  highlight link dotNotation                 Keyword
  highlight link typescriptFuncKeyword       Keyword
  highlight link typescriptVariableKeyword   SpecialChar
  highlight link typescriptVariableKeyword   SpecialChar
  " highlight link jsOperators            Keyword
endfun

fun! s:SetCustomCssSyntaxHighlights()
  syntax match cssProperty                        /\v.+\ze:/ 

  highlight link cssProperty                  Keyword
endfun

augroup javascript_custom_syntax_highlights 
  :autocmd!
  :autocmd FileType apexcode :call <SID>SetCustomJavaScriptSyntaxHighlights()
  :autocmd FileType scss*,css,sass :call <SID>SetCustomCssSyntaxHighlights()
augroup END


