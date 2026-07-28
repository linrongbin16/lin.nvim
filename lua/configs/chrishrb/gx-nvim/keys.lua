local keymap = require("util.keymap")

local M = {
  keymap.set_lazily({ "n", "x" }, "gx", "<cmd>Browse<cr>", { desc = "Open url in browser" }),
}

return M
