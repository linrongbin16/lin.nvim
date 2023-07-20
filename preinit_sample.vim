" Please copy this file to 'preinit.vim' to enable it.

let g:lin_nvim_options = {
            \ 'diagnostic': {
            \   'sign': {
            \       'error': '',
            \       'warning': '',
            \       'info': '',
            \       'hint': '',
            \       'ok': '',
            \   },
            \ },
            \ 'ui': {
            \   'border': 'rounded',
            \   'winblend': 15,
            \   'pumblend': 15,
            \   'layout': {
            \       'middle': { 'scale': 0.8 },
            \       'large': { 'scale': 0.9 },
            \   },
            \ },
            \ 'perf': {
            \   'file': {
            \       'maxsize': 1024 * 1024 * 5,
            \   },
            \ },
            \ }