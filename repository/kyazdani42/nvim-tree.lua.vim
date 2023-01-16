function! s:LinDefineNvimTreeKeys(k) abort
    execute printf('nnoremap <silent> <buffer> <%s-,> :<C-u>NvimTreeResize -10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-Left> :<C-u>NvimTreeResize -10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-.> :<C-u>NvimTreeResize +10<CR>', a:k)
    execute printf('nnoremap <silent> <buffer> <%s-Right> :<C-u>NvimTreeResize +10<CR>', a:k)
endfunction

function! s:LinNvimTreeSettings() abort
    " key mapping

    " resize explorer width
    call s:LinDefineNvimTreeKeys('D')
    call s:LinDefineNvimTreeKeys('A')
    call s:LinDefineNvimTreeKeys('M')
    call s:LinDefineNvimTreeKeys('C')
endfunction

augroup LinNvimTreeAuGroup
    autocmd!
    autocmd FileType NvimTree call s:LinNvimTreeSettings()
augroup END
