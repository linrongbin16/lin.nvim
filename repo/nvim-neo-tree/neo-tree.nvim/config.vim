function! s:NeotreeSettings() abort
    " key mapping
    nnoremap <silent> <buffer> <Leader>> :vertical resize +10<CR>
    nnoremap <silent> <buffer> <Leader>< :vertical resize -10<CR>
endfunction

augroup neotree_startup_augroup
    autocmd!
    autocmd FileType neo-tree call s:NeotreeSettings()
    autocmd VimEnter * Neotree reveal
augroup END
