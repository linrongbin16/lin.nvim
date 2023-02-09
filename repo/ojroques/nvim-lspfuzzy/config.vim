" show diagnostics in current buffer
nnoremap <silent> <Leader>ds     :call LinExecuteOnEditableBuffer("LspDiagnostics 0")<CR>
" show all diagnostics
nnoremap <silent> <Leader>da     :call LinExecuteOnEditableBuffer("LspDiagnosticsAll")<CR>
