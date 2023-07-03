local loader = require("builtin.utils.loader")

-- basic options
vim.cmd("source $HOME/.nvim/lua/builtin/options.vim")

-- plugins
require("config.folke.lazy-nvim.config")

-- colorschemes and other things
vim.cmd("source $HOME/.nvim/lua/builtin/colors.vim")
vim.cmd("source $HOME/.nvim/lua/builtin/others.vim")