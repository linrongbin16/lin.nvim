" opts
let $FZF_DEFAULT_OPTS = '--ansi --info=inline --height=100% --layout=reverse'

" preview/bat
let $BAT_THEME='ansi'
let $BAT_STYLE='numbers,changes,header'

" ui
let g:fzf_layout =
            \ {
            \   'window': {
            \       'width': luaeval("require('builtin.utils.constants').ui.layout.large.scale"),
            \       'height': luaeval("require('builtin.utils.constants').ui.layout.large.scale")
            \   }
            \ }
let g:fzf_preview_window = ['right,50%', 'ctrl-l']

" command prefix
let g:fzf_command_prefix = 'Fzf'

" action
let g:fzf_action={
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit',
            \ }

" git log
let g:fzf_commits_log_options='--graph --abbrev-commit --date=short --color=always --pretty='.shellescape('%C(auto)%cd %h%d %s')