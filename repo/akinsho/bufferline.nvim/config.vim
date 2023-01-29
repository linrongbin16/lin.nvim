function! LinBufferGoto(n) abort
    call LinUtilExecute(printf("lua require('bufferline').go_to_buffer(%d, true)", a:n))
endfunction

" go to absolute buffer
nnoremap <silent> <Leader>1 :call LinBufferGoto(1)<CR>
nnoremap <silent> <Leader>2 :call LinBufferGoto(2)<CR>
nnoremap <silent> <Leader>3 :call LinBufferGoto(3)<CR>
nnoremap <silent> <Leader>4 :call LinBufferGoto(4)<CR>
nnoremap <silent> <Leader>5 :call LinBufferGoto(5)<CR>
nnoremap <silent> <Leader>6 :call LinBufferGoto(6)<CR>
nnoremap <silent> <Leader>7 :call LinBufferGoto(7)<CR>
nnoremap <silent> <Leader>8 :call LinBufferGoto(8)<CR>
nnoremap <silent> <Leader>9 :call LinBufferGoto(9)<CR>
nnoremap <silent> <Leader>0 :call LinBufferGoto(-1)<CR>

" go to next/previous buffer, close buffer
nnoremap <silent> ]b :call LinUtilExecute("BufferLineCycleNext")<CR>
nnoremap <silent> [b :call LinUtilExecute("BufferLineCyclePrev")<CR>
nnoremap <silent> <Leader>bd :call LinUtilExecute("Bdelete!")<CR>

" re-order current buffer to next/previous position
nnoremap <silent> <Leader>> :call LinUtilExecute("BufferLineMoveNext")<CR>
nnoremap <silent> <Leader>< :call LinUtilExecute("BufferLineMovePrev")<CR>
