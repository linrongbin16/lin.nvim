local constants = require("builtin.constants")

require("which-key").setup({
  delay = 200,
  win = {
    border = constants.window.border,
    wo = {
      winblend = constants.window.blend,
    },
  },
})
