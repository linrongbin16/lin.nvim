local constants = require("builtin.utils.constants")

local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
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
    root = vim.fn.stdpath("config") .. "/lazy",
    ui = {
        size = {
            width = constants.ui.layout.scale,
            height = constants.ui.layout.scale,
        },
        border = constants.ui.border,
    },
}

local user_plugins_ok, _ = pcall(require, "user_plugins")
require("lazy").setup(user_plugins_ok and "user_plugins" or "plugins", opts)

require("builtin.utils.keymap").set_key(
    "n",
    "<leader>lz",
    ":Lazy<CR>",
    { silent = false, desc = "Open Lazy" }
)