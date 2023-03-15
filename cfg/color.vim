""" ---- Color schemes ----

let s:colors=[
            \ 'tokyonight',
            \ 'PaperColor',
            \ 'catppuccin',
            \ 'kanagawa',
            \ 'iceberg',
            \ 'nightfox',
            \ 'everforest',
            \ 'seoul256',
            \ 'monokai',
            \ 'gruvbox-material',
            \ 'github_dark',
            \ 'dracula',
            \ 'sonokai',
            \ 'OceanicNext',
            \ 'tender',
            \ 'solarized8',
            \ 'gruvbox',
            \ 'onedark',
            \ 'codedark',
            \ 'zenburn',
            \ 'apprentice',
            \ 'rose-pine',
            \ 'lucario',
            \ 'srcery',
            \ 'material',
            \ 'spaceduck',
            \ 'edge',
            \ 'deus',
            \ 'falcon',
            \ 'oxocarbon',
            \ 'nightfly',
            \ 'pencil',
            \ 'nord',
            \ 'moonfly',
            \ 'challenger_deep',
            \ 'embark',
            \]

function! s:rand_int(n) abort
    return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:n
endfunction

function s:switch_color(update, ...)
    " echom 'a:0:' . string(a:0) . ', a:000:' . string(a:000)
    if a:0 > 0 && strlen(a:1) > 0
        " echom 'a:1:' . string(a:1)
        execute 'colorscheme ' . a:1
    else
        let idx = s:rand_int(len(s:colors))
        execute 'colorscheme ' . s:colors[idx]
    endif
    if a:update
        execute 'diffupdate'
        execute 'syntax sync fromstart'
    endif
endfunction

command! -bang -nargs=? SwitchColor call s:switch_color(<bang>0, <f-args>)