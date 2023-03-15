" ---- Basic ----
source $HOME/.nvim/cfg/basic.vim
lua require('cfg.lsp.basic')

" ---- Plugin ----
lua require('repo.folke.lazy-nvim.config')

" ---- Others ----
source $HOME/.nvim/cfg/color.vim
source $HOME/.nvim/cfg/other.vim