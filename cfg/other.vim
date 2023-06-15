
""" ---- GUI font ----
if has('win32') || has('win64')
    " for Windows
    set guifont=Hack\ NFM:h10
elseif has('mac')
    " for macOS
    set guifont=Hack\ Nerd\ Font\ Mono:h13
else
    " for other Linux
    set guifont=Hack\ Nerd\ Font\ Mono:h10
endif

""" ---- Random colorscheme ----
SwitchColor

""" ---- CTRL+?/CMD+? ----
if exists('$VIMRUNTIME/mswin.vim')
    source $VIMRUNTIME/mswin.vim
endif
if has('mac') && exists('$VIMRUNTIME/macmap.vim')
    source $VIMRUNTIME/macmap.vim
endif

""" ---- Biscuits ----
lua require('cfg.keymap').map('n', '<leader>ww', ':noa w<CR>', {silent=false, desc="Save file without formatting"})
lua require('cfg.keymap').map('n', '<leader>qt', ':quit<CR>', {silent=false, desc=":quit"})
lua require('cfg.keymap').map('n', '<leader>qT', ':quit!<CR>', {silent=false, desc=":quit!"})
lua require('cfg.keymap').map('n', '<leader>qa', ':qall<CR>', {silent=false, desc=":qall"})
lua require('cfg.keymap').map('n', '<leader>qA', ':qall!<CR>', {silent=false, desc=":qall!"})
lua require('cfg.keymap').map('n', '<leader>zz', "@=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>", {silent=false, desc="Toggle folding"})
lua require('cfg.keymap').map('x', '<leader>y', ":w! $HOME/.nvim/.copypaste<CR>", {silent=false, desc="Copy visual-selected text to cache"})
lua require('cfg.keymap').map('n', '<leader>p', ":r $HOME/.nvim/.copypaste<CR>", {silent=false, desc="Paste from cache"})

""" ---- Optimization ----
" Large file
augroup optimization_augroup
    autocmd!
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > luaeval("require('cfg.const').perf.file.maxsize") | syntax clear | setlocal eventignore+=FileType | setlocal undolevels=-1 | endif
augroup END

""" ---- User settings ----
if filereadable(expand('~/.nvim/cfg/user.vim'))
    source $HOME/.nvim/cfg/user.vim
endif