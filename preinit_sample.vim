" Please copy this file to 'preinit.vim' to enable it.

let g:lin_nvim_builtin_constants = {
            \ 'diagnostics': {
            \   'error': '',
            \   'warning': '',
            \   'info': '',
            \   'hint': '',
            \   'ok': '',
            \ },
            \ 'window': {
            \   'border': 'rounded',
            \   'blend': 15,
            \ },
            \ 'layout': {
            \   'window': { 'scale': 0.85 },
            \   'large': { 'scale': 0.9 },
            \   'sidebar': { 'scale': 0.2, 'min': 20, 'max': 60 },
            \   'input': { 'scale': 0.3, 'min': 30, 'max': 60 },
            \   'select': { 'scale': 0.5, 'min': 40, 'max': 100 },
            \ },
            \ 'perf': {
            \   'maxfilesize': 1024 * 1024 * 5,
            \ },
            \ }
