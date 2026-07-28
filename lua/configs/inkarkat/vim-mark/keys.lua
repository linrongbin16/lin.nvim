local keymap = require("util.keymap")

local M = {
  -- toggle cursor word in normal/visual mode
  keymap.set_lazily("n", "<leader>mk", "<Plug>MarkSet", { desc = "Toggle highlighting mark" }),
  keymap.set_lazily(
    "x",
    "<leader>mk",
    "<Plug>MarkIWhiteSet",
    { desc = "Toggle highlighting mark" }
  ),
  -- clear all words
  keymap.set_lazily(
    "n",
    "<leader>mK",
    "<Plug>MarkAllClear",
    { desc = "Clear all highlighting marks" }
  ),

  -- search next/previous word
  keymap.set_lazily("n", "<leader>mn", "<Plug>MarkSearchNext", { desc = "Next highlighting mark" }),
  keymap.set_lazily(
    "n",
    "<leader>mN",
    "<Plug>MarkSearchPrev",
    { desc = "Previous highlighting mark" }
  ),
}

return M
