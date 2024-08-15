" Needs to be near the end because it changes the way some of the
" other plugins like ctrl-p, startify, NERDTree, etc. work.
let g:sol = {
  \"gui": {
    \"base03": "#002b36",
    \"base02": "#073642",
    \"base01": "#586e75",
    \"base00": "#657b83",
    \"base0": "#839496",
    \"base1": "#93a1a1",
    \"base2": "#eee8d5",
    \"base3": "#fdf6e3",
    \"yellow": "#ffd700",
    \"orange": "#ff5f00",
    \"red": "#dc322f",
    \"magenta": "#d33682",
    \"violet": "#875fff",
    \"blue": "	#00afff",
    \"cyan": "#00ffff",
    \"green": "#00ff00"
  \},
  \"cterm": {
    \"base03": 8,
    \"base02": 0,
    \"base01": 10,
    \"base00": 11,
    \"base0": 12,
    \"base1": 14,
    \"base2": 7,
    \"base3": 15,
    \"yellow": 220,
    \"orange": 202,
    \"red": 1,
    \"magenta": 5,
    \"violet": 99,
    \"blue": 39,
    \"cyan": 14,
    \"green": 46
  \}
\}
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif
augroup devicons
  autocmd!
  autocmd FileType nerdtree setlocal nolist
  autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=ALL
  autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=ALL
  autocmd FileType nerdtree setlocal conceallevel=3
  autocmd FileType nerdtree setlocal concealcursor=nvic
augroup END
function! DeviconsColors(config)
  let colors = keys(a:config)
  augroup devicons_colors
    autocmd!
    for color in colors
      if color == 'normal'
        exec 'autocmd FileType nerdtree,startify if &background == ''dark'' | '.
          \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base01.' ctermfg='.g:sol.cterm.base01.' | '.
          \ 'else | '.
          \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base1.' ctermfg='.g:sol.cterm.base1.' | '.
          \ 'endif'
      elseif color == 'emphasize'
        exec 'autocmd FileType nerdtree,startify if &background == ''dark'' | '.
          \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base1.' ctermfg='.g:sol.cterm.base1.' | '.
          \ 'else | '.
          \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base01.' ctermfg='.g:sol.cterm.base01.' | '.
          \ 'endif'
      else
        exec 'autocmd FileType nerdtree,startify highlight devicons_'.color.' guifg='.g:sol.gui[color].' ctermfg='.g:sol.cterm[color]
      endif
      exec 'autocmd FileType nerdtree,startify syntax match devicons_'.color.' /\v'.join(a:config[color], '|').'/ containedin=ALL'
    endfor
  augroup END
endfunction
let g:devicons_colors = {
  \'normal': ['', '', '', ''],
  \'emphasize': ['', '', '', '', '', '', '', '', '', ''],
  \'yellow': ['', '', ''],
  \'orange': ['', '', '', '' ,'', 'λ', '', ''],
  \'red': ['', '', '', '', '', '', '', '', ''],
  \'magenta': [''],
  \'violet': ['', '', '', '', ''],
  \'blue': ['', '', '','', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
  \'cyan': ['', '', '', '', ''],
  \'green': ['', '', '', '', '']
\}
call DeviconsColors(g:devicons_colors)
command RefreshDevicons call DeviconsColors(g:devicons_colors)

let g:webdevicons_enable_nerdtree = 1
" let g:NERDTreeDirArrows=0
" let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:NERDTreeDisableFileExtensionHighlight = 0
let g:NERDTreeFileExtensionHighlightFullName = 1

let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = '🗂'   
let g:DevIconsDefaultFolderCloseSymbol = '🗂'
let g:DevIconsDefaultFolderOpenSymbol = '📂'
let g:NERDTreeDisablePatternMatchHighlight = 1
let g:NERDTreeSyntaxDisableDefaultExtensions = 1
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['conf'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['json'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['xml'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['html'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cmp'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['evt'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cls'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['apex'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['soql'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['svg'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['forceignore'] = ''
