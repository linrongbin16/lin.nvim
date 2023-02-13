local constants = require("conf/constants")

require("mason").setup({
  ui = {
    border = constants.ui.border,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("conf/keymap").map(
  "n",
  "<leader>ms",
  ":Mason<CR>",
  { silent = false, desc = "Open Mason" }
)
