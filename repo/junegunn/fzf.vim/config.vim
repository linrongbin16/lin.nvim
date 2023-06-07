" `rg --column --line-number --no-heading --color=always --smart-case`
let s:rg_command='rg --column -n --no-heading --color=always -S'

let s:fzf_bin=expand('~/.nvim/bin')
if has('win32') || has('win64')
    let $PATH .= ';' . s:fzf_bin
else
    let $PATH .= ':' . s:fzf_bin
endif

function! s:make_fzf_live_grep_options(query, reload_command, live_grep_command)
    return [
                \ '--disabled',
                \ '--print-query',
                \ '--delimiter=:',
                \ '--multi',
                \ '--query', a:query,
                \ '--bind', 'ctrl-d:preview-page-down,ctrl-u:preview-page-up',
                \ '--bind', 'ctrl-g:unbind(change,ctrl-g)+change-prompt(Rg> )+enable-search+change-header(:: <ctrl-r> to Regex Search)+rebind(ctrl-r)',
                \ '--bind', 'ctrl-r:unbind(ctrl-r)+change-prompt(*Rg> )+disable-search+change-header(:: <ctrl-g> to Fuzzy Search)+reload('.a:live_grep_command.')+rebind(change,ctrl-g)',
                \ '--bind', 'change:reload:'.a:reload_command,
                \ '--header', ':: <ctrl-g> to Fuzzy Search',
                \ '--prompt', '*Rg> '
                \ ]
endfunction

function! s:lin_fzf_live_grep(query, fullscreen)
    let command_fmt = 'fzf_live_grep.py %s'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': s:make_fzf_live_grep_options(a:query, reload_command, 'fzf_live_grep.py {q}')}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfLiveGrep call s:lin_fzf_live_grep(<q-args>, <bang>0)

function! s:lin_fzf_unrestricted_live_grep(query, fullscreen)
    let command_fmt = 'fzf_unrestricted_live_grep.py %s'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': s:make_fzf_live_grep_options(a:query, reload_command, 'fzf_unrestricted_live_grep.py {q}')}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfUnrestrictedLiveGrep call s:lin_fzf_unrestricted_live_grep(<q-args>, <bang>0)

function! s:lin_fzf_live_grep_no_glob(query, fullscreen)
    let command_fmt = s:rg_command.' %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': s:make_fzf_live_grep_options(a:query, reload_command, s:rg_command.' {q} || true')}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfLiveGrepNoGlob call s:lin_fzf_live_grep_no_glob(<q-args>, <bang>0)

function! s:lin_fzf_unrestricted_live_grep_no_glob(query, fullscreen)
    let command_fmt = s:rg_command.' -uu %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': s:make_fzf_live_grep_options(a:query, reload_command, s:rg_command.' -uu {q} || true')}
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
            \ call fzf#run(
            \   fzf#wrap({
            \       'source': 'git branch -a --color',
            \       'options': [
            \           '--no-multi',
            \           '--print-query',
            \           '--expect=ctrl-c,ctrl-q,esc',
            \           '--delimiter=:',
            \           '--prompt', 'Branches> ',
            \           '--bind', 'ctrl-d:preview-page-down,ctrl-u:preview-page-up',
            \           '--bind', 'ctrl-l:toggle-preview',
            \           '--preview-window', 'nohidden:border:nowrap:right:50%',
            \           '--preview', 'fzf_git_branches_preview.py {}',
            \       ]},
            \       <bang>0
            \   )
            \ )