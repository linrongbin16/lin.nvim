command! -bang -nargs=* LinFzfUnrestrictedRg
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S -uu -g '!.git/' ".shellescape(<q-args>), 1,
            \ fzf#vim#with_preview(), <bang>0)

function! s:linFzfAdvancedRg(query, fullscreen)
    let command_fmt = 'rg --column --no-heading --color=always -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

function! s:linFzfUnrestrictedAdvancedRg(query, fullscreen)
    let command_fmt = "rg --column --no-heading --color=always -S -uu -g '!.git/' -- %s || true"
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* LinFzfPreciseRg call s:linFzfAdvancedRg(<q-args>, <bang>0)

command! -bang -nargs=* LinFzfUnrestrictedPreciseRg call s:linFzfUnrestrictedAdvancedRg(<q-args>, <bang>0)

command! -bang -nargs=0 LinFzfRgCWord
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S ".shellescape(expand('<cword>')), 1,
            \ fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=0 LinFzfUnrestrictedRgCWord
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S -uu -g '!.git/' ".shellescape(expand('<cword>')), 1,
            \ fzf#vim#with_preview(), <bang>0)

if executable('fd')
    let s:lin_find_command = 'fd'
elseif executable('fdfind')
    let s:lin_find_command = 'fdfind'
endif
 
command! -bang -nargs=? -complete=dir LinFzfUnrestrictedFiles
    \ call fzf#run(
    \   fzf#vim#with_preview(
    \     fzf#wrap({ 'source': s:lin_find_command." -tf -tl -i -u --exclude '.git' ".shellescape(<q-args>) }, <bang>0)
    \   )
    \ )
 
command! -bang -nargs=? -complete=dir LinFzfFilesCWord
    \ call fzf#run(
    \   fzf#vim#with_preview(
    \     fzf#wrap({ 'source': s:lin_find_command.' -tf -tl -i '.shellescape(expand('<cword>')) }, <bang>0)
    \   )
    \ )
 
command! -bang -nargs=? -complete=dir LinFzfUnrestrictedFilesCWord
    \ call fzf#run(
    \   fzf#vim#with_preview(
    \     fzf#wrap({ 'source': s:lin_find_command." -tf -tl -i -u --exclude '.git' ".shellescape(expand('<cword>')) }, <bang>0)
    \   )
    \ )


""" Text
" live grep
nnoremap <silent> <space>r      :call LinExecuteOnEditableBuffer("FzfRg")<CR>
nnoremap <silent> <space>ur     :call LinExecuteOnEditableBuffer("LinFzfUnrestrictedRg")<CR>
nnoremap <silent> <space>pr     :call LinExecuteOnEditableBuffer("LinFzfPreciseRg")<CR>
nnoremap <silent> <space>upr    :call LinExecuteOnEditableBuffer("LinFzfUnrestrictedPreciseRg")<CR>
" cursor word/string
nnoremap <silent> <space>wr     :call LinExecuteOnEditableBuffer("LinFzfRgCWord")<CR>
nnoremap <silent> <space>uwr    :call LinExecuteOnEditableBuffer("LinFzfUnrestrictedRgCWord")<CR>
" lines in opened buffers
nnoremap <silent> <space>ln     :call LinExecuteOnEditableBuffer("FzfLines")<CR>
" tags
nnoremap <silent> <space>tg     :call LinExecuteOnEditableBuffer("FzfTags")<CR>

""" Files
" files
nnoremap <silent> <space>f      :call LinExecuteOnEditableBuffer("FzfFiles")<CR>
nnoremap <silent> <C-p>         :call LinExecuteOnEditableBuffer("FzfFiles")<CR>
nnoremap <silent> <space>uf     :call LinExecuteOnEditableBuffer("LinFzfUnrestrictedFiles")<CR>
" files by cursor word
nnoremap <silent> <space>wf     :call LinExecuteOnEditableBuffer("LinFzfFilesCWord")<CR>
nnoremap <silent> <space>uwf    :call LinExecuteOnEditableBuffer("LinFzfUnrestrictedFilesCWord")<CR>
" opened buffers
nnoremap <silent> <space>b      :call LinExecuteOnEditableBuffer("FzfBuffers")<CR>
" history files/oldfiles
nnoremap <silent> <space>hf     :call LinExecuteOnEditableBuffer("FzfHistory")<CR>

""" History
" search history
nnoremap <silent> <space>hs     :call LinExecuteOnEditableBuffer("FzfHistory/")<CR>
" vim command history
nnoremap <silent> <space>hc     :call LinExecuteOnEditableBuffer("FzfHistory:")<CR>

""" Lsp
" diagnostics in current buffer
nnoremap <silent> <space>db     :call LinExecuteOnEditableBuffer("LspDiagnostics 0")<CR>
" all diagnostics
nnoremap <silent> <space>da     :call LinExecuteOnEditableBuffer("LspDiagnosticsAll")<CR>

""" Git
" git commits
nnoremap <silent> <space>gc     :call LinExecuteOnEditableBuffer("FzfCommits")<CR>
" git files
nnoremap <silent> <space>gf     :call LinExecuteOnEditableBuffer("FzfGFiles")<CR>
" git status files
nnoremap <silent> <space>gs     :call LinExecuteOnEditableBuffer("FzfGFiles?")<CR>

""" Vim
" vim marks
nnoremap <silent> <space>mk     :call LinExecuteOnEditableBuffer("FzfMarks")<CR>
" vim key mappings
nnoremap <silent> <space>mp     :call LinExecuteOnEditableBuffer("FzfMaps")<CR>
" vim commands
nnoremap <silent> <space>cm     :call LinExecuteOnEditableBuffer("FzfCommands")<CR>
" vim help tags
nnoremap <silent> <space>ht     :call LinExecuteOnEditableBuffer("FzfHelptags")<CR>
" vim colorschemes
nnoremap <silent> <space>cs     :call LinExecuteOnEditableBuffer("FzfColors")<CR>
" vim filetypes
nnoremap <silent> <space>tp     :call LinExecuteOnEditableBuffer("FzfFiletypes")<CR>
