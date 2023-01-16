" Enable more colors
let g:mwDefaultHighlightingPalette = 'maximum'

" Disable default key mappings, only enable a few, for * and # conflict with 'haya14busa/is.vim'
let g:mw_no_mappings = 1

" set/clear mark under cursor in normal mode
nmap <Leader>m <Plug>MarkSet
" set/clear mark on selected code in visual mode
xmap <Leader>m <Plug>MarkIWhiteSet

" clear all marks
nmap <Leader>M <Plug>MarkConfirmAllClear
" nmap <Leader>M <Plug>MarkAllClear

" search next/previous mark
nmap <Leader>* <Plug>MarkSearchNext
nmap <Leader># <Plug>MarkSearchPrev
