local constants = require("builtin.constants")

require("which-key").setup({
  delay = function(ctx)
    return ctx.plugin and 100 or 200
  end,
  win = {
    border = constants.window.border,
    wo = {
      winblend = constants.window.blend,
    },
  },
})
