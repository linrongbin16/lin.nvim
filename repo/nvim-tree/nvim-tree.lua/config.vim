function! s:NvimTreeSettings() abort
    " key mapping
    nnoremap <silent> <buffer> <Leader>> :NvimTreeResize +10<CR>
    nnoremap <silent> <buffer> <Leader>< :NvimTreeResize -10<CR>
endfunction

augroup nvim_tree_key_binding_augroup
    autocmd!
    autocmd FileType NvimTree call s:NvimTreeSettings()
augroup END

" Find current file in nvim-tree
nnoremap <Leader>nf :NvimTreeFindFile<CR>
