" `rg --column --line-number --no-heading --color=always --smart-case`
let s:rg_command='rg --column -n --no-heading --color=always -S'
" `fd --color=never --type f --type symlink --follow`
if executable('fd')
    let s:fd_command = 'fd -cnever -tf -tl -L'
elseif executable('fdfind')
    let s:fd_command = 'fdfind -cnever -tf -tl -L'
endif

let s:fzf_bin=expand('~/.nvim/bin/fzf')
if has('win32') || has('win64')
    let $PATH .= ';' . s:fzf_bin
else
    let $PATH .= ':' . s:fzf_bin
endif

let s:live_grep_provider='live_grep_provider.py'
let s:unrestricted_live_grep_provider='unrestricted_live_grep_provider.py'
let s:git_branches_previewer='git_branches_previewer.py'

let s:bind_preview='ctrl-d:preview-page-down,ctrl-u:preview-page-up'
let s:help_preview_page='<ctrl-u>/<ctrl-d> to Scroll Up/Down Preview'
let s:help_fuzzy_search='<ctrl-g> to Fuzzy Search'
let s:help_regex_search='<ctrl-r> to Regex Search'
let s:header_regex_search_with_preview=':: '.s:help_regex_search.', '.s:help_preview_page
let s:header_fuzzy_search_with_preview=':: '.s:help_fuzzy_search.', '.s:help_preview_page
let s:header_preview=':: '.s:help_preview_page

function! s:live_grep(query, provider, fullscreen)
    let command_fmt = a:provider.' %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': [
                \ '--disabled',
                \ '--query', a:query,
                \ '--bind', s:bind_preview,
                \ '--bind', 'ctrl-g:unbind(change,ctrl-g)+change-prompt(Rg> )+enable-search+change-header('.s:header_regex_search_with_preview.')+rebind(ctrl-r)',
                \ '--bind', 'ctrl-r:unbind(ctrl-r)+change-prompt(*Rg> )+disable-search+change-header('.s:header_fuzzy_search_with_preview.')+reload('.reload_command.')+rebind(change,ctrl-g)',
                \ '--bind', 'change:reload:'.reload_command,
                \ '--header', s:header_fuzzy_search_with_preview,
                \ '--prompt', '*Rg> '
                \ ]}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -bang -nargs=* FzfLiveGrep call s:live_grep(<q-args>, s:live_grep_provider, <bang>0)

command! -bang -nargs=* FzfUnrestrictedLiveGrep call s:live_grep(<q-args>, s:unrestricted_live_grep_provider, <bang>0)

" command! -bang -nargs=* FzfLiveGrepNoGlob call s:live_grep(<q-args>, s:rg_command, <bang>0)

" command! -bang -nargs=* FzfUnrestrictedLiveGrepNoGlob call s:live_grep(<q-args>, s:rg_command.' -uu', <bang>0)

function! s:buffers(query, fullscreen)
    let spec = {'options': [
                \ '--bind', s:bind_preview,
                \ '--header', s:header_preview,
                \ ],
                \ 'placeholder': '{1}'}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#buffers(a:query, spec, a:fullscreen)
endfunction

command! -bang -nargs=? -complete=dir FzfBuffers2 call s:buffers(<q-args>, <bang>0)

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
                \ '--bind', s:bind_preview,
                \ '--bind', 'change:reload:'.reload_command,
                \ '--prompt', prompt,
                \ '--header', s:header_preview,
                \ ]}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#grep(initial_command, spec, a:fullscreen)
endfunction

command! -bang -nargs=0 FzfWord call s:word(expand('<cword>'), s:rg_command.' -w', <bang>0, 0)

command! -bang -nargs=0 FzfUnrestrictedWord call s:word(expand('<cword>'), s:rg_command.' -w -uu', <bang>0, 0)

command! -bang -nargs=0 FzfUpperWORD call s:word(toupper(expand('<cword>')), s:rg_command.' -w', <bang>0, 1)

command! -bang -nargs=0 FzfUnrestrictedUpperWORD call s:word(toupper(expand('<cword>')), s:rg_command.' -w -uu', <bang>0, 1)

function! s:files(query, provider, fullscreen)
    let command_fmt = a:provider.' %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let spec = { 'source': initial_command,
                \ 'options': [
                \ '--bind', s:bind_preview,
                \ '--header', s:header_preview,
                \ ]}
    let spec = fzf#vim#with_preview(spec)
    call fzf#vim#files(a:query, spec, a:fullscreen)
endfunction

command! -bang -nargs=? -complete=dir FzfFiles2 call s:files(<q-args>, s:fd_command, <bang>0)

command! -bang -nargs=? -complete=dir FzfUnrestrictedFiles call s:files(<q-args>, s:fd_command.' -u', <bang>0)

command! -bang -nargs=? -complete=dir FzfWordFiles call s:files(expand('<cword>'), s:fd_command, <bang>0)

command! -bang -nargs=? -complete=dir FzfUnrestrictedWordFiles call s:files(expand('<cword>'), s:fd_command.' -u', <bang>0)

function! s:git_branches(query, provider, fullscreen)
    let command_fmt = a:provider.' %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let spec = { 'source': initial_command,
                \ 'options': [
                \ '--bind', s:bind_preview,
                \ '--prompt', 'GitBranches> ',
                \ '--preview', 'git_branches_previewer.py {}',
                \ '--header', s:header_preview,
                \ ]}
    let spec = fzf#vim#with_preview(fzf#wrap(spec), a:fullscreen)
    call fzf#run(spec)
endfunction

command! -bang -nargs=0 FzfGitBranches call s:git_branches(<q-args>, 'git branch -a --color --list', <bang>0)