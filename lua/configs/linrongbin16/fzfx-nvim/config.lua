local constants = require("builtin.constants")

require("fzfx").setup({
  popup = {
    win_opts = {
      height = constants.layout.window.scale,
      width = constants.layout.window.scale,
    },
  },
})
