" ---- Basic ----
source $HOME/.nvim/conf/basic.vim
lua require('conf/lsp')

" ---- Plugin ----
lua require('repo/folke/lazy-nvim/config')

" ---- Generated ----
lua require('lspservers')
source $HOME/.nvim/colorschemes.vim
source $HOME/.nvim/settings.vim
