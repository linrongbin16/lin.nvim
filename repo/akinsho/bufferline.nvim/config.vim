function! Lin#Bufferline#Goto(n) abort
    call Lin#Util#Execute(printf("lua require('bufferline').go_to_buffer(%d, true)", a:n))
endfunction

" go to absolute buffer
nnoremap <silent> <Leader>1 :call Lin#Bufferline#Goto(1)<CR>
nnoremap <silent> <Leader>2 :call Lin#Bufferline#Goto(2)<CR>
nnoremap <silent> <Leader>3 :call Lin#Bufferline#Goto(3)<CR>
nnoremap <silent> <Leader>4 :call Lin#Bufferline#Goto(4)<CR>
nnoremap <silent> <Leader>5 :call Lin#Bufferline#Goto(5)<CR>
nnoremap <silent> <Leader>6 :call Lin#Bufferline#Goto(6)<CR>
nnoremap <silent> <Leader>7 :call Lin#Bufferline#Goto(7)<CR>
nnoremap <silent> <Leader>8 :call Lin#Bufferline#Goto(8)<CR>
nnoremap <silent> <Leader>9 :call Lin#Bufferline#Goto(9)<CR>
nnoremap <silent> <Leader>0 :call Lin#Bufferline#Goto(-1)<CR>

" go to next/previous buffer, close buffer
nnoremap <silent> ]b :call Lin#Util#Execute("BufferLineCycleNext")<CR>
nnoremap <silent> [b :call Lin#Util#Execute("BufferLineCyclePrev")<CR>
nnoremap <silent> <Leader>bd :call Lin#Util#Execute("Bdelete!")<CR>

" re-order current buffer to next/previous position
nnoremap <silent> <Leader>> :call Lin#Util#Execute("BufferLineMoveNext")<CR>
nnoremap <silent> <Leader>< :call Lin#Util#Execute("BufferLineMovePrev")<CR>
