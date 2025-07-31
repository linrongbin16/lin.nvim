local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("fzfx").setup({
  popup = {
    win_opts = {
      height = layout.editor.height(constants.layout.window.scale, 1) + 2,
      width = layout.editor.width(constants.layout.window.scale, 1),
    },
  },
})
