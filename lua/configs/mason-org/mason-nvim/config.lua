local constants = require("builtin.constants")
local path = require("mason-core.path")

require("mason").setup({
  install_root_dir = path.concat({ vim.fn.stdpath("config"), "mason" }),
  ui = {
    border = constants.window.border,
    width = constants.window.layout.middle.scale,
    height = constants.window.layout.middle.scale,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})
