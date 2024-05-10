local constants = require("builtin.constants")
local uv = vim.uv or vim.loop

local ensure_installed = {
  "vim",
  "lua",
  "markdown",
  "javascript",
  "typescript",
  "tsx",
}

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
