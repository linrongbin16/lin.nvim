local constants = require("builtin.constants")

require("fzfx").setup({
  popup = {
    win_opts = {
      height = constants.window.layout.middle.scale,
      width = constants.window.layout.middle.scale,
    },
  },
  debug = {
    enable = false,
    file_log = true,
  },
})
