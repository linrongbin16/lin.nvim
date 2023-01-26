" go to absolute buffer
nnoremap <silent> <Leader>1 :lua require("bufferline").go_to_buffer(1, true)<CR>
nnoremap <silent> <Leader>2 :lua require("bufferline").go_to_buffer(2, true)<CR>
nnoremap <silent> <Leader>3 :lua require("bufferline").go_to_buffer(3, true)<CR>
nnoremap <silent> <Leader>4 :lua require("bufferline").go_to_buffer(4, true)<CR>
nnoremap <silent> <Leader>5 :lua require("bufferline").go_to_buffer(5, true)<CR>
nnoremap <silent> <Leader>6 :lua require("bufferline").go_to_buffer(6, true)<CR>
nnoremap <silent> <Leader>7 :lua require("bufferline").go_to_buffer(7, true)<CR>
nnoremap <silent> <Leader>8 :lua require("bufferline").go_to_buffer(8, true)<CR>
nnoremap <silent> <Leader>9 :lua require("bufferline").go_to_buffer(9, true)<CR>
nnoremap <silent> <Leader>0 :lua require("bufferline").go_to_buffer(-1, true)<CR>

" go to next/previous buffer, close buffer
nnoremap <silent> ]b :BufferLineCycleNext<CR>
nnoremap <silent> [b :BufferLineCyclePrev<CR>
nnoremap <silent> <Leader>bd :Bdelete!<CR>

" re-order current buffer to next/previous position
nnoremap <silent> <Leader>> :BufferLineMoveNext<CR>
nnoremap <silent> <Leader>< :BufferLineMovePrev<CR>

