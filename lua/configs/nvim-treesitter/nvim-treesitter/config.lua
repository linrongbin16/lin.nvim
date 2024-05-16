local constants = require("builtin.constants")
local message = require("builtin.utils.message")
local uv = vim.uv or vim.loop

local ensure_installed = {}

local user_ensure_installed_module = "configs.nvim-treesitter.nvim-treesitter.ensure_installed"
local user_ensure_installed_ok, user_ensure_installed = pcall(require, user_ensure_installed_module)

if user_ensure_installed_ok then
  if type(user_ensure_installed) == "table" then
    ensure_installed = user_ensure_installed
  else
    message.err(string.format("Error loading '%s' lua module!", user_ensure_installed_module))
  end
end

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = ensure_installed,
  auto_install = true,
  matchup = { -- for vim-matchup
    enable = true,
  },
  highlight = {
    enable = true,
    -- disable for super large file
    disable = function(lang, buf)
      local max_filesize = constants.perf.maxfilesize
      local ok, stats = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok and stats and stats.size > max_filesize
    end,
    additional_vim_regex_highlighting = false,
  },
})
