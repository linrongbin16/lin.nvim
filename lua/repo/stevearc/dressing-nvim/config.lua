local constants = require("conf/constants")
local close_mappings =
  { ["<ESC>"] = "Close", ["<C-[>"] = "Close", ["<C-c>"] = "Close" }
local window_transparency = 0
local window_min_width = { 50, 0.2 }

require("dressing").setup({
  input = {
    border = constants.ui.border,
    min_width = window_min_width,
    win_options = {
      winblend = window_transparency,
    },
    mappings = {
      n = close_mappings,
      i = close_mappings,
    },
  },
  select = {
    nui = {
      border = {
        style = constants.ui.border,
      },
    },
    builtin = {
      border = constants.ui.border,
      min_width = window_min_width,
      win_options = {
        winblend = window_transparency,
      },
      mappings = close_mappings,
    },
  },
})
