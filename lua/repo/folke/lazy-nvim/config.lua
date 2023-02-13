local constants = require("conf/constants")

-- For Windows: $env:USERPROFILE\AppData\Local\nvim-data\lazy\lazy.nvim
-- For *NIX: ~/.local/share/nvim/lazy/lazy.nvim
local lazypath = string.format(
    "%s%slazy%slazy.nvim",
    vim.fn.stdpath("data"),
    constants.fs.path_separator,
    constants.fs.path_separator
)

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local opts = {
    ui = {
        border = constants.ui.border,
    },
}

require("lazy").setup("plugins", opts)
