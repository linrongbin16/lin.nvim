" Enable more colors
let g:mwDefaultHighlightingPalette = 'maximum'

" Disable default key mappings, for * and # conflict with 'haya14busa/is.vim'
let g:mw_no_mappings = 1

" Only enable a few of them

" toggle mark
nmap <Leader>m <Plug>MarkToggle
" clear all marks
nmap <Leader>n <Plug>MarkConfirmAllClear
" nmap <Leader>N <Plug>MarkAllClear

" search next/previous mark
nmap <Leader>* <Plug>MarkSearchNext
nmap <Leader># <Plug>MarkSearchPrev
