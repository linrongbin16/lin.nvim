" set/clear mark under cursor in normal mode
nmap <Leader>m <Plug>MarkSet
" set/clear mark on selected code in visual mode
xmap <Leader>m <Plug>MarkIWhiteSet

" search next/previous mark
nmap <Leader>* <Plug>MarkSearchNext
nmap <Leader># <Plug>MarkSearchPrev

" clear all marks
nnoremap <Leader>M :MarkClear<CR>
