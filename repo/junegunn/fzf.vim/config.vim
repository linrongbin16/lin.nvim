let s:fzf_bin=expand('~/.nvim/bin/fzf')
if has('win32') || has('win64')
    let $PATH .= ';' . s:fzf_bin
else
    let $PATH .= ':' . s:fzf_bin
endif

let s:live_grep_provider='live_grep_provider.py'
let s:unrestricted_live_grep_provider='unrestricted_live_grep_provider.py'
let s:git_branches_previewer='git_branches_previewer.py'

function! s:word(query, provider, fullscreen, upper)
    let command_fmt = a:provider.' %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    if a:upper
        let prompt = '*WORD> '
    else
        let prompt = '*Word> '
    endif
    let spec = {'options': [
                \ '--disabled',
                \ '--query', a:query,
                \ '--bind', 'change:reload:'.reload_command,
                \ '--prompt', prompt,
                \ ]}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, spec, a:fullscreen)
endfunction

function! s:git_branches(query, provider, fullscreen)
    let command_fmt = a:provider.' %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let spec = { 'source': initial_command,
                \ 'options': [
                \ '--prompt', 'GitBranches> ',
                \ '--preview', 'git_branches_previewer.py {}',
                \ ]}
    let spec = fzf#vim#with_preview(fzf#wrap(spec), a:fullscreen)
    call fzf#run(spec)
endfunction

command! -bang -nargs=0 FzfGitBranches call s:git_branches(<q-args>, 'git branch -a --color --list', <bang>0)