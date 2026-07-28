local keymap = require("util.keymap")

local M = {
  keymap.set_lazily("n", "gd", "<CMD>Glance definitions<CR>", { desc = "Go to LSP definition" }),
  keymap.set_lazily("n", "gr", "<CMD>Glance references<CR>", { desc = "Go to LSP reference" }),
  keymap.set_lazily(
    "n",
    "gt",
    "<CMD>Glance type_definitions<CR>",
    { desc = "Go to LSP type definition" }
  ),
  keymap.set_lazily(
    "n",
    "gi",
    "<CMD>Glance implementations<CR>",
    { desc = "Go to LSP implementation" }
  ),
}

return M
