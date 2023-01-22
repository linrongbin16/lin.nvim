let bufferline = get(g:, 'bufferline', {})
let bufferline.animation = v:false
let bufferline.icons = 'both'
let bufferline.no_name_title = '[No Name]'
let bufferline.maximum_length = 40

function! s:LinVimDefineBarbarKeys(k) abort
    " go to buffer-1~9, or the last buffer
    " <D-?>/<A-?>/<M-?>/<C-?>
    " ?: 0-9
    execute printf('nnoremap <silent> <expr> <%s-1> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 1\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-2> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 2\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-3> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 3\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-4> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 4\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-5> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 5\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-6> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 6\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-7> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 7\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-8> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 8\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-9> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferGoto 9\<CR>"', a:k)
    execute printf('nnoremap <silent> <expr> <%s-0> (&filetype ==# "NvimTree" ? "\<C-w>\<C-w>" : "").":BufferLast\<CR>"', a:k)

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


call s:LinVimDefineBarbarKeys('D')
call s:LinVimDefineBarbarKeys('A')
call s:LinVimDefineBarbarKeys('M')
call s:LinVimDefineBarbarKeys('C')

" go to next/previous buffer, close buffer
nnoremap <silent> <expr> ]b (&filetype ==# "NvimTree" ? "\<c-w>\<c-w>" : '').":BufferNext\<CR>"
nnoremap <silent> <expr> [b (&filetype ==# "NvimTree" ? "\<c-w>\<c-w>" : '').":BufferPrevious\<CR>"
nnoremap <silent> <expr> <Leader>bd (&filetype ==# "NvimTree" ? "\<c-w>\<c-w>" : '').":BufferClose\<CR>"
