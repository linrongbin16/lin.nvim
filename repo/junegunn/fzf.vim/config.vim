command! -bang -nargs=* LinFzfUnrestrictedRg
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S -uu --glob=!.git/ ".shellescape(<q-args>), 1,
            \ fzf#vim#with_preview(), <bang>0)

function! s:LinFzfAdvancedRg(query, fullscreen)
    let command_fmt = 'rg --column --no-heading --color=always -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

function! s:LinFzfUnrestrictedAdvancedRg(query, fullscreen)
    let command_fmt = 'rg --column --no-heading --color=always -S -uu --glob=!.git/ -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* LinFzfPreciseRg call s:LinFzfAdvancedRg(<q-args>, <bang>0)

command! -bang -nargs=* LinFzfUnrestrictedPreciseRg call s:LinFzfUnrestrictedAdvancedRg(<q-args>, <bang>0)

command! -bang -nargs=0 LinFzfRgCWord
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S ".shellescape(expand('<cword>')), 1,
            \ fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=0 LinFzfUnrestrictedRgCWord
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S -uu --glob=!.git/ ".shellescape(expand('<cword>')), 1,
            \ fzf#vim#with_preview(), <bang>0)

if executable('fd')
    let s:lin_find_command = 'fd'
elseif executable('fdfind')
    let s:lin_find_command = 'fdfind'
endif
 
command! -bang -nargs=? -complete=dir LinFzfUnrestrictedFiles
    \ call fzf#run(
    \   fzf#vim#with_preview(
    \     fzf#wrap({ 'source': s:lin_find_command.' -tf -tl -i -u --exclude ".git" '.shellescape(<q-args>) }, <bang>0)
    \   )
    \ )


""" Text
" live grep
nnoremap <silent> <space>r      :call LinExecuteOnBuffer("FzfRg")<CR>
nnoremap <silent> <space>ur     :call LinExecuteOnBuffer("LinFzfUnrestrictedRg")<CR>
nnoremap <silent> <space>pr     :call LinExecuteOnBuffer("LinFzfPreciseRg")<CR>
nnoremap <silent> <space>upr    :call LinExecuteOnBuffer("LinFzfUnrestrictedPreciseRg")<CR>
" cursor word/string
nnoremap <silent> <space>w      :call LinExecuteOnBuffer("LinFzfRgCWord")<CR>
nnoremap <silent> <space>uw     :call LinExecuteOnBuffer("LinFzfUnrestrictedRgCWord")<CR>
" lines in opened buffers
nnoremap <silent> <space>ln     :call LinExecuteOnBuffer("FzfLines")<CR>
" tags
nnoremap <silent> <space>tg     :call LinExecuteOnBuffer("FzfTags")<CR>

""" Files
" files
nnoremap <silent> <space>f      :call LinExecuteOnBuffer("FzfFiles")<CR>
nnoremap <silent> <C-p>         :call LinExecuteOnBuffer("FzfFiles")<CR>
nnoremap <silent> <space>uf     :call LinExecuteOnBuffer("LinFzfUnrestrictedFiles")<CR>
" opened buffers
nnoremap <silent> <space>b      :call LinExecuteOnBuffer("FzfBuffers")<CR>
" history files/oldfiles
nnoremap <silent> <space>hf     :call LinExecuteOnBuffer("FzfHistory")<CR>

""" History
" search history
nnoremap <silent> <space>hs     :call LinExecuteOnBuffer("FzfHistory/")<CR>
" vim command history
nnoremap <silent> <space>hc     :call LinExecuteOnBuffer("FzfHistory:")<CR>

""" Lsp
" diagnostics in current buffer
nnoremap <silent> <space>db     :call LinExecuteOnBuffer("LspDiagnostics 0")<CR>
" all diagnostics
nnoremap <silent> <space>da     :call LinExecuteOnBuffer("LspDiagnosticsAll")<CR>

""" Git
" git commits
nnoremap <silent> <space>gc     :call LinExecuteOnBuffer("FzfCommits")<CR>
" git files
nnoremap <silent> <space>gf     :call LinExecuteOnBuffer("FzfGFiles")<CR>
" git status files
nnoremap <silent> <space>gs     :call LinExecuteOnBuffer("FzfGFiles?")<CR>

""" Vim
" vim marks
nnoremap <silent> <space>mk     :call LinExecuteOnBuffer("FzfMarks")<CR>
" vim key mappings
nnoremap <silent> <space>mp     :call LinExecuteOnBuffer("FzfMaps")<CR>
" vim commands
nnoremap <silent> <space>cm     :call LinExecuteOnBuffer("FzfCommands")<CR>
" vim help tags
nnoremap <silent> <space>ht     :call LinExecuteOnBuffer("FzfHelptags")<CR>
" vim colorschemes
nnoremap <silent> <space>cs     :call LinExecuteOnBuffer("FzfColors")<CR>
" vim filetypes
nnoremap <silent> <space>tp     :call LinExecuteOnBuffer("FzfFiletypes")<CR>
