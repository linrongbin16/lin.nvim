local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("fzfx").setup({
  popup = {
    win_opts = {
      height = math.min(layout.editor.height(constants.layout.window.scale, 1) + 2, vim.o.lines),
      width = layout.editor.width(constants.layout.window.scale, 1),
    },
  },
})
