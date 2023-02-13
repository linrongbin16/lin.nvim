" use fd for fzf file finding, instead of default find
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd -tf -tl -i'
elseif executable('fdfind')
  let $FZF_DEFAULT_COMMAND = 'fdfind -tf -tl -i'
else
  echohl ErrorMsg
  echo "Error: `fd` or `fdfind` not found!"
  echohl None
endif
" use base16 theme for better color capatibility
let $BAT_THEME='base16'

" Fzf command prefix
let g:fzf_command_prefix = 'Fzf'
