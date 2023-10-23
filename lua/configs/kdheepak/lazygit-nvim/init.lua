local neoconf = require("neoconf")

vim.g.lazygit_floating_window_winblend =
    neoconf.get("linopts.ui.blend.winblend")
vim.g.lazygit_floating_window_scaling_factor =
    neoconf.get("linopts.ui.floatwin.scale")
