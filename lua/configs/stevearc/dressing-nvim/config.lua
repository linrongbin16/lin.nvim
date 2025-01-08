local constants = require("builtin.constants")

local close_mappings = { ["<ESC>"] = "Close", ["<C-[>"] = "Close", ["<C-c>"] = "Close" }
local min_width_value = constants.window.layout.prompt.min
local min_width_rate = constants.window.layout.prompt.scale
local min_width = { min_width_value, min_width_rate }

require("dressing").setup({
  input = {
    border = constants.window.border,
    prefer_width = min_width_rate,
    min_width = min_width,
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
      min_width = min_width_value,
    },
    builtin = {
      border = constants.window.border,
      min_width = min_width,
      win_options = {
        winblend = constants.window.blend,
      },
      mappings = close_mappings,
    },
  },
})
