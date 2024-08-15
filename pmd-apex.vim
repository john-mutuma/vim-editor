
" Author: Johannes Wienke <languitar@semipol.de> / John Mutuma johnmutuma5@gmail.com
" Description: PMD for Apex files - this should be used with ale linter - add
"              this file to ~/.vim/plugged/ale/ale_linters/apexcode/pmd.vim
"              once you have installed your ale plugin

function! ale_linters#apexcode#pmd#Handle(buffer, lines) abort
    let l:pattern = '"\(\d\+\)",".*","\(.\+\)","\(\d\+\)","\(\d\+\)","\(.\+\)","\(.\+\)","\(.\+\)"$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'type': 'W',
        \   'lnum': l:match[4] + 0,
        \   'text': l:match[5],
        \   'code': l:match[6] . ' - ' . l:match[7],
        \})
    endfor

    return l:output
endfunction

function! ale_linters#apexcode#pmd#GetCommand(buffer) abort
    return 'pmd pmd'
    \ . ale#Var(a:buffer, 'apexcode_pmd_options')
    \ . ' -f csv'
    \ . ' -d %t'
endfunction

if !exists('g:ale_apexcode_pmd_options')
    let g:ale_apexcode_pmd_options = ' -R rulesets/apex/quickstart.xml'
endif

call ale#linter#Define('apexcode', {
\   'name': 'pmd',
\   'executable': 'pmd',
\   'command': function('ale_linters#apexcode#pmd#GetCommand'),
\   'callback': 'ale_linters#apexcode#pmd#Handle',
\})
