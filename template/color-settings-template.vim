""" ---- Color schemes ----

let s:lin_colorschemes=[
    \ 'solarized8',
    \ 'monokai',
    \ 'dracula',
    \ 'neodark',
    \ 'srcery',
    \ 'palenight',
    \ 'onedark',
    \ 'rigel',
    \ 'edge',
    \ 'gruvbox-material',
    \ 'everforest',
    \ 'sonokai',
    \ 'material',
    \ 'github_dark',
    \ 'tokyonight',
    \ 'kanagawa',
    \ 'nightfox'
    \ ]

function! s:LinRandint(n) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:n
endfunction

function LinNextRandomColorScheme()
    if len(s:lin_colorschemes) > 0
        let idx = s:LinRandint(len(s:lin_colorschemes))
        execute 'colorscheme ' . s:lin_colorschemes[idx]
    endif
endfunction

function LinNextRandomColorSchemeSync()
    if len(s:lin_colorschemes) > 0
        let idx = s:LinRandint(len(s:lin_colorschemes))
        execute 'colorscheme ' . s:lin_colorschemes[idx]
        execute 'syntax sync fromstart'
    endif
endfunction


