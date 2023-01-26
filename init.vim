" ---- Init ----
source $HOME/.vim/conf/basic.vim
source $HOME/.vim/conf/filetype.vim
lua require('conf/lsp')

" ---- Plugin ----
lua require('repo/folke/lazy-nvim/config')

" ---- Others ----
lua require('conf/lspservers')
source $HOME/.vim/conf/colors.vim
source $HOME/.vim/conf/settings.vim
