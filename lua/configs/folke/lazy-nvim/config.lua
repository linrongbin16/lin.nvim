local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.constants").ui.layout

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
        border = constants.ui.border,
        size = {
            width = layout.width,
            height = layout.height,
        },
    },
}

require("lazy").setup("plugins", opts)

require("builtin.utils.keymap").set_key(
    "n",
    "<leader>lz",
    ":Lazy<CR>",
    { silent = false, desc = "Open Lazy" }
)