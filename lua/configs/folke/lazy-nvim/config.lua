local constants = require("builtin.utils.constants")
local message = require("builtin.utils.message")
local uv = vim.uv or vim.loop

local stdpath_config = vim.fn.stdpath("config")

local lazypath = stdpath_config .. "/lazy/lazy.nvim"
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
    root = stdpath_config .. "/lazy",
    git = {
        timeout = 60,
    },
    ui = {
        size = {
            width = constants.ui.layout.middle.scale,
            height = constants.ui.layout.middle.scale,
        },
        border = constants.ui.border,
    },
}

local plugins_blacklist_path = stdpath_config .. "/lua/plugins_blacklist.lua"
if uv.fs_stat(plugins_blacklist_path) then
    local plugins_blacklist = require("plugins_blacklist")
    assert(
        type(plugins_blacklist) == "table"
    )
    opts.defaults = {
        cond = function(plugin_spec)
            local uri = plugin_spec[1]
            return not plugins_blacklist[uri]
        end,
    }
end

require("lazy").setup("plugins", opts)

require("builtin.utils.keymap").set_key(
    "n",
    "<leader>lz",
    ":Lazy<CR>",
    { silent = false, desc = "Open Lazy" }
)
