local constants = require("builtin.constants")

require("fzfx").setup({
  override_fzf_opts = { "--border=rounded" },
  popup = {
    win_opts = {
      height = constants.layout.window.scale,
      width = constants.layout.window.scale,
    },
  },
  debug = {
    enable = false,
    file_log = true,
  },
})
