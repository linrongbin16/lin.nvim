""" ---- Color schemes ----

let s:colors=[
    \ 'None',
    \ 'nightfly',
    \ 'moonfly',
    \ 'catppuccin',
    \ 'challenger_deep',
    \ 'iceberg',
    \ 'nightfox',
    \ 'embark',
    \ 'falcon',
    \ 'tokyonight',
    \ 'solarized',
    \ 'seoul256',
    \ 'gruvbox-baby',
    \ 'material',
    \ 'OceanicNext',
    \ 'dracula',
    \ 'onedark',
    \ 'PaperColor',
    \ 'spaceduck',
    \ 'pencil',
    \ 'github_dark',
    \ 'lucario',
    \ 'kanagawa',
    \ 'rigel',
    \ 'apprentice',
    \ 'rose-pine',
    \ 'edge',
    \ 'everforest',
    \ 'sonokai',
    \ 'nord',
    \ 'srcery',
    \]

function! s:rand_int(n) abort
    return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:n
endfunction

function s:lin_next_color(update, ...)
    " echom 'a:0:' . string(a:0) . ', a:000:' . string(a:000)
    if a:0 > 0
        " echom 'a:1:' . string(a:1)
        execute 'colorscheme ' . a:1
    else
        if len(s:colors) > 0
            let idx = s:rand_int(len(s:colors))
            execute 'colorscheme ' . s:colors[idx]
        else
            " execute 'normal! \<Esc>'
            echohl ErrorMsg
            echomsg 'Error: no colorscheme installed, check `~/.nvim/colorschemes.vim`!'
            echohl None
        endif
    endif
    if a:update
        execute 'diffupdate'
        execute 'syntax sync fromstart'
    endif
endfunction

command! -bang -nargs=? NextColor call s:lin_next_color(<bang>0, <f-args>)
