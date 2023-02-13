" mark word
nnoremap <silent> <Leader>km :call InterestingWords('n')<CR>
vnoremap <silent> <Leader>km :call InterestingWords('v')<CR>
" unmark word
nnoremap <silent> <Leader>kM :call UncolorAllWords()<CR>
" navigate next word
nnoremap <silent> <Leader>kn :call WordNavigation(1)<CR>
" navigate previous word
nnoremap <silent> <Leader>kN :call WordNavigation(0)<CR>
