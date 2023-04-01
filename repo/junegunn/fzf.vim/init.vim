" use fd for fzf file finding, instead of default find
if executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd --color=never --type f --type symlink --follow --ignore-case'
elseif executable('fdfind')
    let $FZF_DEFAULT_COMMAND = 'fdfind --color=never --type f --type symlink --follow --ignore-case'
else
    echohl ErrorMsg
    echo 'Error: `fd` or `fdfind` not found!'
    echohl None
endif
let $FZF_DEFAULT_OPTS = '--ansi --info=inline --height=100% --layout=reverse'

" preview/bat
let $BAT_THEME='ansi'
let $BAT_STYLE='numbers,changes,header'

" ui
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.85 } }
let g:fzf_preview_window = ['right,40%', 'ctrl-l']

" command prefix
let g:fzf_command_prefix = 'Fzf'

" action
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit',
            \ }