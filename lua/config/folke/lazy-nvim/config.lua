local const = require("cfg.const")
local layout = require("cfg.const").ui.layout

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
        border = const.ui.border,
        size = {
            width = layout.width,
            height = layout.height,
        },
    },
}

require("lazy").setup("cfg.plugins", opts)

require("cfg.keymap").map(
    "n",
    "<leader>lz",
    ":Lazy<CR>",
    { silent = false, desc = "Open Lazy" }
)