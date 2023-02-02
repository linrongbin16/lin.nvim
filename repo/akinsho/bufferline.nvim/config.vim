function! linGotoBuffer(n) abort
    call LinExecuteOnEditableBuffer(printf("lua require('bufferline').go_to_buffer(%d, true)", a:n))
endfunction

" go to absolute buffer
nnoremap <silent> <Leader>1 :call linGotoBuffer(1)<CR>
nnoremap <silent> <Leader>2 :call linGotoBuffer(2)<CR>
nnoremap <silent> <Leader>3 :call linGotoBuffer(3)<CR>
nnoremap <silent> <Leader>4 :call linGotoBuffer(4)<CR>
nnoremap <silent> <Leader>5 :call linGotoBuffer(5)<CR>
nnoremap <silent> <Leader>6 :call linGotoBuffer(6)<CR>
nnoremap <silent> <Leader>7 :call linGotoBuffer(7)<CR>
nnoremap <silent> <Leader>8 :call linGotoBuffer(8)<CR>
nnoremap <silent> <Leader>9 :call linGotoBuffer(9)<CR>
nnoremap <silent> <Leader>0 :call linGotoBuffer(-1)<CR>

" go to next/previous buffer, close buffer
nnoremap <silent> ]b :call LinExecuteOnEditableBuffer("BufferLineCycleNext")<CR>
nnoremap <silent> [b :call LinExecuteOnEditableBuffer("BufferLineCyclePrev")<CR>
nnoremap <silent> <Leader>bd :Bdelete!<CR>

" re-order current buffer to next/previous position
nnoremap <silent> <Leader>> :call LinExecuteOnEditableBuffer("BufferLineMoveNext")<CR>
nnoremap <silent> <Leader>< :call LinExecuteOnEditableBuffer("BufferLineMovePrev")<CR>
