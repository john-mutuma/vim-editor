" set this as a symbolic link in .vim/plugin

" datetime date
:nnoremap <leader>dtd "=<SID>getDate()<CR>p
:inoremap <leader>dtd <C-R>=<SID>getDate()<CR>

" datetime time
:nnoremap <leader>dtt "=<SID>getTime()<CR>p
:inoremap <leader>dtt <C-R>=<SID>getTime()<CR>
"
" datetime now
:nnoremap <leader>dtn "=<SID>getNow()<CR>p
:inoremap <leader>dtn <C-R>=<SID>getNow()<CR>

function! s:getDate()
  let dateToday = strftime("%Y %b %d")
  return dateToday
endfunction

function! s:getTime()
  let currentTime = strftime("%H:%M:%S")
  return currentTime
endfunction

function! s:getNow()
  let now = strftime("%c")
  return now
endfunction

