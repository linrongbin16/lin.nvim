" Bigger highlight delay for better performance
let g:Illuminate_delay = 500

" Highlight color
augroup LinVimIlluminateAuGroup
    autocmd!
    autocmd VimEnter * hi link illuminatedWord Visual
augroup END
