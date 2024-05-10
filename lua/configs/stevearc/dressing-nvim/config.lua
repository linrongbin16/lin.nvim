local constants = require("builtin.constants")

local close_mappings = { ["<ESC>"] = "Close", ["<C-[>"] = "Close", ["<C-c>"] = "Close" }
local window_min_width_value = 50
local window_min_width_rate = 0.2
local window_min_width = { window_min_width_value, window_min_width_rate }

require("dressing").setup({
  input = {
    border = constants.window.border,
    min_width = window_min_width,
    win_options = {
      winblend = constants.window.blend,
    },
    mappings = {
      n = close_mappings,
      i = close_mappings,
    },
  },
  select = {
    nui = {
      border = {
        style = constants.window.border,
      },
      win_options = {
        winblend = constants.window.blend,
      },
      min_width = window_min_width_value,
    },
    builtin = {
      border = constants.window.border,
      min_width = window_min_width,
      win_options = {
        winblend = constants.window.blend,
      },
      mappings = close_mappings,
    },
  },
})
