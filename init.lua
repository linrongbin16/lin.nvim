-- basic options
vim.cmd("source $HOME/.nvim/lua/builtin/options.vim")

-- plugins
require("configs.folke.lazy-nvim.config")

-- other options
vim.cmd("source $HOME/.nvim/lua/builtin/colors.vim")
vim.cmd("source $HOME/.nvim/lua/builtin/others.vim")