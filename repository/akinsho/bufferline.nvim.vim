function! s:BufferLineKeys(k) abort
    " go to buffer-1~9, or the last buffer
    " <D-?>/<A-?>/<M-?>/<C-?>
    " ?: 0-9
    execute printf('nnoremap <expr> <%s-1> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(1, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-2> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(2, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-3> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(3, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-4> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(4, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-5> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(5, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-6> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(6, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-7> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(7, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-8> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(8, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-9> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(9, true)\<CR>"', a:k)
    execute printf('nnoremap <expr> <%s-0> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":lua require(\"bufferline\").go_to_buffer(-1, true)\<CR>"', a:k)

    " go to next/previous buffer
    " <D-?>/<A-?>/<M-?>/<C-?>
    " ?: ,/Left/./Right
    execute printf('nnoremap <silent> <expr> <%s-.> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferNext\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-Right> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferNext\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-,> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferPrevious\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-Left> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferPrevious\<CR>"', a:k)

    " re-order current buffer to next/previous position
    " <D-S-?>/<A-S-?>/<M-S-?>/<C-S-?>
    " ?: ,/Left/./Right
    execute printf('nnoremap <silent> <expr> <%s-S-,> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferMovePrevious\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-S-Left> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferMovePrevious\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-S-.> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferMoveNext\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-S-Right> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferMoveNext\<CR>"', a:k)
endfunction

call s:BufferLineKeys('D')
call s:BufferLineKeys('A')
call s:BufferLineKeys('M')
call s:BufferLineKeys('C')

