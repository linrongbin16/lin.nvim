local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")
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
    timeout = 300,
  },
  rocks = {
    enabled = false,
  },
  ui = {
    size = {
      width = layout.editor.width(constants.layout.window.scale, 1),
      height = layout.editor.height(constants.layout.window.scale, 1),
    },
    border = constants.window.border,
  },
  performance = {
    disabled_plugins = {
      "netrwPlugin",
      "matchit",
      "matchparen",
      "gzip",
      "tarPlugin",
      "zipPlugin",
      "tutor",
      "tohtml",
      "man",
    },
  },
}

local disabled_plugins_entry = stdpath_config .. "/lua/disabled_plugins.lua"
if uv.fs_stat(disabled_plugins_entry) then
  local disabled_plugins = require("disabled_plugins")
  assert(type(disabled_plugins) == "table")
  opts.defaults = {
    cond = function(plugin_spec)
      local uri = plugin_spec[1]
      return not disabled_plugins[uri]
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
