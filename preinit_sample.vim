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
            \       'middle': { 'scale': 0.85 },
            \       'large': { 'scale': 0.9 },
            \       'sidebar': { 'scale': 0.2, 'min': 30, 'max': 60 },
            \   },
            \ },
            \ 'perf': {
            \   'file': {
            \       'maxsize': 1024 * 1024 * 5,
            \   },
            \ },
            \ }