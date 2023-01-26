""" ---- Color schemes ----

let s:lin_colorschemes=[
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

function! s:LinRandnum(n) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:n
endfunction

function LinNextRandomColorScheme()
    if len(s:lin_colorschemes) > 0
        let idx = s:LinRandnum(len(s:lin_colorschemes))
        execute 'colorscheme ' . s:lin_colorschemes[idx]
    endif
endfunction

function LinNextRandomColorSchemeSync()
    if len(s:lin_colorschemes) > 0
        let idx = s:LinRandnum(len(s:lin_colorschemes))
        execute 'colorscheme ' . s:lin_colorschemes[idx]
        execute 'syntax sync fromstart'
    endif
endfunction

