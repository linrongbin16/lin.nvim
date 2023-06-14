" opts
let $FZF_DEFAULT_OPTS = '--ansi --info=inline --height=100% --layout=reverse'

" preview/bat
let $BAT_THEME='ansi'
let $BAT_STYLE='numbers,changes,header'

" ui
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.9 } }
let g:fzf_preview_window = ['right,50%', 'ctrl-l']

" command prefix
let g:fzf_command_prefix = 'Fzf'

" action
let g:fzf_action={
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit',
            \ }