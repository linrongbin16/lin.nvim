" ---- Init ----
source $HOME/.vim/conf/basic.vim
source $HOME/.vim/conf/filetype.vim
lua require('conf/lsp')

" ---- Plugin ----
lua require('repo/folke/lazy-nvim/config')

" ---- Generated ----
lua require('lspservers')
source $HOME/.vim/colorschemes.vim
source $HOME/.vim/settings.vim
