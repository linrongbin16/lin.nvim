function! s:NvimTreeSettings() abort
    " key mapping
    nnoremap <silent> <buffer> <Leader>> :NvimTreeResize +10<CR>
    nnoremap <silent> <buffer> <Leader>< :NvimTreeResize -10<CR>
endfunction

augroup nvim_tree_key_binding_augroup
    autocmd!
    autocmd FileType NvimTree call s:NvimTreeSettings()
augroup END

" Toggle explorer
nnoremap <Leader>nto :NvimTreeToggle<CR>
" Find current focused file
nnoremap <Leader>ntf :NvimTreeFindFile<CR>
