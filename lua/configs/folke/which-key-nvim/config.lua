local constants = require("builtin.constants")

require("which-key").setup({
  delay = 300,
  win = {
    border = constants.window.border,
    wo = {
      winblend = constants.window.blend,
    },
  },
})
