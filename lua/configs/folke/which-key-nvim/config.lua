local constants = require("builtin.constants")

require("which-key").setup({
  win = {
    border = constants.window.border,
    wo = {
      winblend = constants.window.blend,
    },
  },
})
