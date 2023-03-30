local const = require("cfg.const")
local width_on_editor = require("cfg.ui").width_on_editor
local height_on_editor = require("cfg.ui").height_on_editor
local big_layout = require("cfg.const").ui.layout.big

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
            width = width_on_editor(
                big_layout.width.pct,
                big_layout.width.min,
                big_layout.width.max
            ),
            height = height_on_editor(
                big_layout.height.pct,
                big_layout.height.min,
                big_layout.height.max
            ),
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