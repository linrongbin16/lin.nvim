" `fd --color=never --type f --type symlink --follow --ignore-case`
if executable('fdfind')
    let $FZF_DEFAULT_COMMAND = 'fdfind -cnever -tf -tl -L -i'
elseif executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd -cnever -tf -tl -L -i'
endif
let $FZF_DEFAULT_OPTS = '--ansi --info=inline --height=100% --layout=reverse'

" preview/bat
let $BAT_THEME='ansi'
let $BAT_STYLE='numbers,changes,header'

" ui
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.85 } }
let g:fzf_preview_window = ['right,50%', 'ctrl-l']

" command prefix
let g:fzf_command_prefix = 'Fzf'

" action
" let g:fzf_action = {
"             \ 'ctrl-s': 'split',
"             \ 'ctrl-v': 'vsplit',
"             \ 'ctrl-t': 'tab split',
"             \ }