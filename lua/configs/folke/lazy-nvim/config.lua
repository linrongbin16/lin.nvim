local neoconf = require("neoconf")
local message = require("builtin.utils.message")

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
            width = neoconf.get("linopts.ui.floatwin.scale"),
            height = neoconf.get("linopts.ui.floatwin.scale"),
        },
        border = neoconf.get("linopts.ui.floatwin.border"),
    },
}

local ok, plugins_blacklist = pcall(require, "plugins_blacklist")
if ok then
    if type(plugins_blacklist) == "table" then
        opts.defaults = {
            cond = function(plugin_spec)
                local uri = plugin_spec[1]
                return not plugins_blacklist[uri]
            end,
        }
    else
        message.warn("Error loading 'user_plugins_blacklist' lua module!")
    end
end

require("lazy").setup("plugins", opts)

require("builtin.utils.keymap").set_key(
    "n",
    "<leader>lz",
    ":Lazy<CR>",
    { silent = false, desc = "Open Lazy" }
)
