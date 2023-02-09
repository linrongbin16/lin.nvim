" set/clear mark under cursor in normal mode
nmap <Leader>km <Plug>MarkSet
" set/clear mark on selected code in visual mode
xmap <Leader>km <Plug>MarkIWhiteSet

" search next/previous mark
nmap <Leader>kn <Plug>MarkSearchNext
nmap <Leader>kN <Plug>MarkSearchPrev

" clear all marks with confirm
nmap <Leader>kM  <Plug>MarkConfirmAllClear
