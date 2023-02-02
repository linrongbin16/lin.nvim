function! LinGotoBuffer(n) abort
    call LinExecuteOnEditableBuffer(printf("lua require('bufferline').go_to_buffer(%d, true)", a:n))
endfunction

" go to absolute buffer
nnoremap <silent> <Leader>1 :call LinGotoBuffer(1)<CR>
nnoremap <silent> <Leader>2 :call LinGotoBuffer(2)<CR>
nnoremap <silent> <Leader>3 :call LinGotoBuffer(3)<CR>
nnoremap <silent> <Leader>4 :call LinGotoBuffer(4)<CR>
nnoremap <silent> <Leader>5 :call LinGotoBuffer(5)<CR>
nnoremap <silent> <Leader>6 :call LinGotoBuffer(6)<CR>
nnoremap <silent> <Leader>7 :call LinGotoBuffer(7)<CR>
nnoremap <silent> <Leader>8 :call LinGotoBuffer(8)<CR>
nnoremap <silent> <Leader>9 :call LinGotoBuffer(9)<CR>
nnoremap <silent> <Leader>0 :call LinGotoBuffer(-1)<CR>

" go to next/previous buffer, close buffer
nnoremap <silent> ]b :call LinExecuteOnEditableBuffer("BufferLineCycleNext")<CR>
nnoremap <silent> [b :call LinExecuteOnEditableBuffer("BufferLineCyclePrev")<CR>
nnoremap <silent> <Leader>bd :Bdelete!<CR>

" re-order current buffer to next/previous position
nnoremap <silent> <Leader>> :call LinExecuteOnEditableBuffer("BufferLineMoveNext")<CR>
nnoremap <silent> <Leader>< :call LinExecuteOnEditableBuffer("BufferLineMovePrev")<CR>
