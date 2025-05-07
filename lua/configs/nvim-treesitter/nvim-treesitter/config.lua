local bigfile = require("builtin.utils.bigfile")

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = {
    enable = true,
    -- disable for super large file
    disable = function(lang, buf)
      return bigfile.is_too_big(buf)
    end,
    additional_vim_regex_highlighting = false,
  },
})
