local lazypath = vim.fs.normalize("~/.nvim") .. "/lazy/lazy.nvim"
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
    border = require("conf/constants").ui.border,
  },
  readme = {
    root = vim.fn.stdpath("state") .. "/lazy/readme",
    files = { "README.md", "lua/**/README.md" },
    -- only generate markdown helptags for plugins that dont have docs
    skip_if_doc_exists = true,
  },
  state = vim.fn.stdpath("config") .. "/lazy/state.json",
}

require("lazy").setup("plugins", opts)

require("conf/keymap").map(
  "n",
  "<leader>lz",
  ":Lazy<CR>",
  { silent = false, desc = "Open Lazy" }
)
