local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "gd", "<CMD>Glance definitions<CR>", { desc = "Go to LSP definition" }),
  set_lazy_key("n", "gr", "<CMD>Glance references<CR>", { desc = "Go to LSP reference" }),
  set_lazy_key(
    "n",
    "gt",
    "<CMD>Glance type_definitions<CR>",
    { desc = "Go to LSP type definition" }
  ),
  set_lazy_key("n", "gi", "<CMD>Glance implementations<CR>", { desc = "Go to LSP implementation" }),
}

return M
