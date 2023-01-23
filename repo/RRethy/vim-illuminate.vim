" Bigger highlight delay for better performance
let g:Illuminate_delay = 700

" Highlight color
augroup LinVimIlluminateAuGroup
    autocmd!
    autocmd VimEnter * hi link illuminatedWord Visual
augroup END
