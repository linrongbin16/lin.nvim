local constants = require("builtin.constants")

require("snacks").setup({
  bigfile = {
    enabled = true,
    notify = true,
    size = constants.perf.maxfilesize,
  },
  indent = {
    enabled = true,
    animate = { enabled = false },
    scope = { enabled = false },
  },
})
