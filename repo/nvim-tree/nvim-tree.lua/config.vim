function! s:NvimTreeKeys(k) abort
    execute printf('nnoremap <silent> <buffer> <%s-,> :NvimTreeResize -10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-Left> :NvimTreeResize -10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-.> :NvimTreeResize +10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-Right> :NvimTreeResize +10<CR>', a:k)
endfunction

function! s:NvimTreeSettings() abort
    " key mapping

    " resize explorer width
    call s:NvimTreeKeys('D')
    call s:NvimTreeKeys('A')
    call s:NvimTreeKeys('M')
    call s:NvimTreeKeys('C')
endfunction

augroup LinNvimTreeAuGroup
    autocmd!
    autocmd FileType NvimTree call s:NvimTreeSettings()
augroup END
