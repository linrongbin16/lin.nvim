local loader = require("builtin.utils.loader")

-- basic options
loader.load("lua/builtin/options.vim")

-- plugins
loader.load("config/folk/lazy-nvim/config.lua")

-- colorschemes and other things
loader.load("lua/builtin/colors.vim")
loader.load("lua/builtin/others.vim")