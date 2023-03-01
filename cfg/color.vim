""" ---- Color schemes ----

let s:colors=[
    \ 'PaperColor',
    \ 'iceberg',
    \ 'kanagawa',
    \ 'nightfox',
    \ 'everforest',
    \ 'onehalfdark',
    \ 'seoul256',
    \ 'gruvbox-material',
    \ 'dracula',
    \ 'sonokai',
    \ 'solarized8',
    \ 'zenburn',
    \ 'apprentice',
    \ 'lucario',
    \ 'srcery',
    \ 'pencil',
    \ 'challenger_deep',
    \ 'gruvbox',
    \ 'onedark',
    \ 'codedark',
    \ 'rose-pine',
    \ 'material',
    \ 'edge',
    \ 'falcon',
    \ 'oxocarbon',
    \ 'nightfly',
    \ 'nord',
    \ 'moonfly',
    \ 'embark',
    \]

function! s:rand_int(n) abort
    return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:n
endfunction

function s:lin_next_color(update, ...)
    " echom 'a:0:' . string(a:0) . ', a:000:' . string(a:000)
    if a:0 > 0 && strlen(a:1) > 0
        " echom 'a:1:' . string(a:1)
        execute 'colorscheme ' . a:1
    else
        if len(s:colors) > 0
            let idx = s:rand_int(len(s:colors))
            execute 'colorscheme ' . s:colors[idx]
        else
            " execute 'normal! \<Esc>'
            echohl ErrorMsg
            echomsg 'Error: no colorscheme installed, please check `~/.nvim/cfg/color.vim`'
            echohl None
        endif
    endif
    if a:update
        execute 'diffupdate'
        execute 'syntax sync fromstart'
    endif
endfunction

command! -bang -nargs=? NextColor call s:lin_next_color(<bang>0, <f-args>)