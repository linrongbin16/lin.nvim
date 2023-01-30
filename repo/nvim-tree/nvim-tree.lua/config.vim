function! s:NvimTreeSettings() abort
    " key mapping
    nnoremap <silent> <buffer> <Leader>> :NvimTreeResize +10<CR>
    nnoremap <silent> <buffer> <Leader>< :NvimTreeResize -10<CR>
endfunction

augroup LinNvimTreeAuGroup
    autocmd!
    autocmd FileType NvimTree call s:NvimTreeSettings()
    autocmd VimEnter * NvimTreeOpen
augroup END
