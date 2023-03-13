""" ---- Color schemes ----

let s:colors=[
            \ 'tokyonight-moon',
            \ 'tokyonight-night',
            \ 'tokyonight-day',
            \ 'tokyonight-storm',
            \ 'tokyonight',
            \ 'PaperColor',
            \ 'catppuccin',
            \ 'catppuccin-frappe',
            \ 'catppuccin-macchiato',
            \ 'catppuccin-mocha',
            \ 'catppuccin-latte',
            \ 'kanagawa-wave',
            \ 'kanagawa',
            \ 'kanagawa-lotus',
            \ 'kanagawa-dragon',
            \ 'iceberg',
            \ 'terafox',
            \ 'carbonfox',
            \ 'nightfox',
            \ 'dayfox',
            \ 'dawnfox',
            \ 'nordfox',
            \ 'duskfox',
            \ 'everforest',
            \ 'seoul256',
            \ 'monokai',
            \ 'gruvbox-material',
            \ 'github_dark_colorblind',
            \ 'github_dark',
            \ 'github_dark_default',
            \ 'github_dimmed',
            \ 'dracula',
            \ 'sonokai',
            \ 'OceanicNext',
            \ 'tender',
            \ 'solarized8',
            \ 'solarized8_flat',
            \ 'solarized8_high',
            \ 'solarized8_low',
            \ 'gruvbox',
            \ 'onedark',
            \ 'zenburn',
            \ 'codedark',
            \ 'apprentice',
            \ 'rose-pine-moon',
            \ 'rose-pine-dawn',
            \ 'rose-pine',
            \ 'rose-pine-main',
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

command! -bang -nargs=? SwitchColor call s:switch_color(<bang>0, <f-args>)