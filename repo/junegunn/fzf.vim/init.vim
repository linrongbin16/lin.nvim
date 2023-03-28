" use fd for fzf file finding, instead of default find
if executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd -tf -tl -i'
elseif executable('fdfind')
    let $FZF_DEFAULT_COMMAND = 'fdfind -tf -tl -i'
else
    echohl ErrorMsg
    echo 'Error: `fd` or `fdfind` not found!'
    echohl None
endif


" preview/bat
" let $BAT_THEME='base16'
let $BAT_STYLE='numbers,header'

" ui
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.85 } }
let g:fzf_preview_window = ['right,40%', 'ctrl-p']

" command prefix
let g:fzf_command_prefix = 'Fzf'