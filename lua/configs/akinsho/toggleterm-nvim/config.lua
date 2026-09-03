local constants = require("api.constants")

require("toggleterm").setup({
  persist_size = false,
  float_opts = {
    width = constants.layout.window.scale,
    height = constants.layout.window.scale,
  },
})
