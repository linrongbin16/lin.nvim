function! s:NvimTreeSettings() abort
    " key mapping
    nnoremap <silent> <buffer> <Leader>> :NvimTreeResize +10<CR>
    nnoremap <silent> <buffer> <Leader>< :NvimTreeResize -10<CR>
endfunction

augroup nvim_tree_augroup
    autocmd!
    autocmd FileType NvimTree call s:NvimTreeSettings()
    autocmd VimEnter * NvimTreeOpen
augroup END
