local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key({ "n", "x" }, "gx", "<cmd>Browse<cr>", { desc = "Open url in browser" }),
}

return M
