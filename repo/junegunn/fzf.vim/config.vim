" `rg --column --line-number --no-heading --color=always --smart-case`
let s:rg_command='rg --column -n --no-heading --color=always -S'

let s:fzf_bin=expand('~/.nvim/bin')
if isdirectory(s:fzf_bin)
    if has('win32') || has('win64')
        let $PATH .= ';' . s:fzf_bin
    else
        let $PATH .= ':' . s:fzf_bin
    endif
endif

function! s:lin_fzf_live_grep(query, fullscreen)
    let command_fmt = 'fzf_live_grep.py %s'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--prompt', '*Rg> ']}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfLiveGrep call s:lin_fzf_live_grep(<q-args>, <bang>0)

function! s:lin_fzf_unrestricted_live_grep(query, fullscreen)
    let command_fmt = 'fzf_unrestricted_live_grep.py %s'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--prompt', '*Rg> ']}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfUnrestrictedLiveGrep call s:lin_fzf_unrestricted_live_grep(<q-args>, <bang>0)

function! s:lin_fzf_live_grep_no_glob(query, fullscreen)
    let command_fmt = s:rg_command.' %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--prompt', '*Rg> ']}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfLiveGrepNoGlob call s:lin_fzf_live_grep_no_glob(<q-args>, <bang>0)

function! s:lin_fzf_unrestricted_live_grep_no_glob(query, fullscreen)
    let command_fmt = s:rg_command.' -uu %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--prompt', '*Rg> ']}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfUnrestrictedLiveGrepNoGlob call s:lin_fzf_unrestricted_live_grep_no_glob(<q-args>, <bang>0)

command! -bang -nargs=0 FzfCWord
            \ call fzf#vim#grep(
            \ s:rg_command." -w ".shellescape(expand('<cword>'))." || true", 1,
            \ fzf#vim#with_preview({'options': ['--prompt', '*word> ']}), <bang>0)

command! -bang -nargs=0 FzfUnrestrictedCWord
            \ call fzf#vim#grep(
            \ s:rg_command." -w -uu ".shellescape(expand('<cword>'))." || true", 1,
            \ fzf#vim#with_preview({'options': ['--prompt', '*word> ']}), <bang>0)

command! -bang -nargs=0 FzfCapitalizedCWORD
            \ call fzf#vim#grep(
            \ s:rg_command." -w ".toupper(shellescape(expand('<cword>')))." || true", 1,
            \ fzf#vim#with_preview({'options': ['--prompt', '*WORD> ']}), <bang>0)

command! -bang -nargs=0 FzfUnrestrictedCapitalizedCWORD
            \ call fzf#vim#grep(
            \ s:rg_command." -w -uu ".toupper(shellescape(expand('<cword>')))." || true", 1,
            \ fzf#vim#with_preview({'options': ['--prompt', '*WORD> ']}), <bang>0)

if executable('fd')
    " `fd --color=never --type f --type symlink --follow --ignore-case`
    let s:fd_command = 'fd -cnever -tf -tl -L -i'
elseif executable('fdfind')
    let s:fd_command = 'fdfind -cnever -tf -tl -L -i'
endif

command! -bang -nargs=? -complete=dir FzfUnrestrictedFiles
            \ call fzf#run(
            \   fzf#vim#with_preview(
            \     fzf#wrap({ 'source': s:fd_command." -u ".shellescape(<q-args>) }, <bang>0)
            \   )
            \ )

" deprecated
command! -bang -nargs=? -complete=dir FzfCWordFiles
            \ call fzf#run(
            \   fzf#vim#with_preview(
            \     fzf#wrap({ 'source': s:fd_command.' '.shellescape(expand('<cword>')) }, <bang>0)
            \   )
            \ )

" deprecated
command! -bang -nargs=? -complete=dir FzfUnrestrictedCWordFiles
            \ call fzf#run(
            \   fzf#vim#with_preview(
            \     fzf#wrap({ 'source': s:fd_command." -u ".shellescape(expand('<cword>')) }, <bang>0)
            \   )
            \ )

command! -bang -nargs=0 FzfGBranches
            \ call fzf#vim#grep(
            \ "git branch -a", 1,
            \ fzf#vim#with_preview({'options': ['--prompt', '*Branches> ']}), <bang>0)