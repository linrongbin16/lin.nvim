command! -bang -nargs=* FzfUnrestrictedRg
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S -uu -g '!.git/' ".shellescape(<q-args>), 1,
            \ fzf#vim#with_preview(), <bang>0)

function! s:lin_fzf_advanced_rg(query, fullscreen)
    let command_fmt = 'rg --column --no-heading --color=always -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

function! s:lin_fzf_unrestricted_advanced_rg(query, fullscreen)
    let command_fmt = "rg --column --no-heading --color=always -S -uu -g '!.git/' -- %s || true"
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfPrecisedRg call s:lin_fzf_advanced_rg(<q-args>, <bang>0)

command! -bang -nargs=* FzfUnrestrictedPrecisedRg call s:lin_fzf_unrestricted_advanced_rg(<q-args>, <bang>0)

command! -bang -nargs=0 FzfCWordRg
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S ".shellescape(expand('<cword>')), 1,
            \ fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=0 FzfUnrestrictedCWordRg
            \ call fzf#vim#grep(
            \ "rg --column --no-heading --color=always -S -uu -g '!.git/' ".shellescape(expand('<cword>')), 1,
            \ fzf#vim#with_preview(), <bang>0)

if executable('fd')
    let s:lin_find_command = 'fd'
elseif executable('fdfind')
    let s:lin_find_command = 'fdfind'
endif

command! -bang -nargs=? -complete=dir FzfUnrestrictedFiles
            \ call fzf#run(
            \   fzf#vim#with_preview(
            \     fzf#wrap({ 'source': s:lin_find_command." -tf -tl -i -u --exclude '.git' ".shellescape(<q-args>) }, <bang>0)
            \   )
            \ )

command! -bang -nargs=? -complete=dir FzfCWordFiles
            \ call fzf#run(
            \   fzf#vim#with_preview(
            \     fzf#wrap({ 'source': s:lin_find_command.' -tf -tl -i '.shellescape(expand('<cword>')) }, <bang>0)
            \   )
            \ )

command! -bang -nargs=? -complete=dir FzfUnrestrictedCWordFiles
            \ call fzf#run(
            \   fzf#vim#with_preview(
            \     fzf#wrap({ 'source': s:lin_find_command." -tf -tl -i -u --exclude '.git' ".shellescape(expand('<cword>')) }, <bang>0)
            \   )
            \ )
