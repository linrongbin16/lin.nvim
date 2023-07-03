""" ---- Other Options ----

" GUI font
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

" random colorscheme
SwitchColor

" ctrl/cmd-?
if exists('$VIMRUNTIME/mswin.vim')
    source $VIMRUNTIME/mswin.vim
endif
if has('mac') && exists('$VIMRUNTIME/macmap.vim')
    source $VIMRUNTIME/macmap.vim
endif

" biscuits
lua require('cfg.keymap').map('n', '<leader>ww', ':noa w<CR>', {silent=false, desc="Save file without formatting"})
lua require('cfg.keymap').map('n', '<leader>qt', ':quit<CR>', {silent=false, desc=":quit"})
lua require('cfg.keymap').map('n', '<leader>qT', ':quit!<CR>', {silent=false, desc=":quit!"})
lua require('cfg.keymap').map('n', '<leader>qa', ':qall<CR>', {silent=false, desc=":qall"})
lua require('cfg.keymap').map('n', '<leader>qA', ':qall!<CR>', {silent=false, desc=":qall!"})
lua require('cfg.keymap').map('n', '<leader>zz', "@=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>", {silent=false, desc="Toggle folding"})
lua require('cfg.keymap').map('x', '<leader>y', ":w! $HOME/.nvim/.copypaste<CR>", {silent=false, desc="Copy visual-selected text to cache"})
lua require('cfg.keymap').map('n', '<leader>p', ":r $HOME/.nvim/.copypaste<CR>", {silent=false, desc="Paste from cache"})

" optimization
augroup optimization_augroup
    autocmd!
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > luaeval("require('cfg.const').perf.file.maxsize") | syntax clear | setlocal eventignore+=FileType | setlocal undolevels=-1 | endif
augroup END

" user options
if filereadable(expand('~/.nvim/lua/builtin/users.vim'))
    source $HOME/.nvim/lua/builtin/users.vim
endif