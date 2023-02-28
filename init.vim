" ---- Basic ----
source $HOME/.nvim/cfg/basic.vim

" ---- Plugin ----
lua require('repo/folke/lazy-nvim/config')

" ---- Others ----
lua require('cfg.lsp')
source $HOME/.nvim/cfg/color.vim
source $HOME/.nvim/cfg/other.vim