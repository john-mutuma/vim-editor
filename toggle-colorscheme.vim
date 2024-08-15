" Toggle day and night {{{
:nnoremap <ESC><ESC><ESC> :call <SID>toggleDayNight()<CR>


augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#2cfbba' gui=underline ctermfg=136 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#2aba5f' gui=underline ctermfg=165 cterm=underline
augroup END

:let g:is_day = 0
function s:toggleDayNight()
  if g:is_day == 1 " it is day
    colorscheme flattened_light  
    set background=light
    hi Normal ctermbg=15
    hi CursorLine cterm=bold ctermbg=254
    hi CursorColumn cterm=bold ctermbg=254
    hi ColorColumn ctermbg=254 guibg=lightgray
    hi Pmenu ctermbg=gray guibg=gray

    let g:is_day = 0
  elseif g:is_day == 0 " it's night
    " colorscheme monokai
    colorscheme molokai
    set background=dark
    hi Normal ctermbg=235
    hi CursorLine cterm=bold ctermbg=237
    hi CursorColumn cterm=bold ctermbg=237
    hi ColorColumn ctermbg=237 guibg=lightgray 
    hi Pmenu ctermbg=23 ctermfg=white guibg=lightgray 
    hi PmenuSel ctermbg=white ctermfg=black
    hi CocFloating ctermbg=66 ctermfg=195
    hi CocErrorFloat ctermbg=lightgray ctermfg=160
    hi CocWarningFloat ctermbg=lightgray ctermfg=172
    hi CocInfoFloat ctermbg=gray ctermfg=lightgray
    " hi CocWarningSign ctermbg=66 ctermfg=214
    " hi CocInfoSign ctermbg=66 ctermfg=195
    " hi CocErrorSign ctermbg=66 ctermfg=160
    hi Visual term=reverse cterm=reverse guibg=Grey
    hi Folded ctermbg=236 ctermfg=245 
    hi Directory ctermfg=76 cterm=bold
    hi Normal ctermfg=253

    let g:is_day = 1
  endif
endfunction

:call <SID>toggleDayNight()
"}}}

