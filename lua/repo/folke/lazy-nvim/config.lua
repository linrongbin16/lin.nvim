local const = require("cfg.const")

local lazypath = vim.fn.expand('$HOME') .. "/.nvim/lazy/lazy.nvim"
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
    root = vim.fn.expand('$HOME') .. "/.nvim/lazy",
    ui = {
        border = const.ui.border,
    },
}

require("lazy").setup("cfg.plugins", opts)

require("cfg.keymap").map(
    "n",
    "<leader>lz",
    ":Lazy<CR>",
    { silent = false, desc = "Open Lazy" }
)
