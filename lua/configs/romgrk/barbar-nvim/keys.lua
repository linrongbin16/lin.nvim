local keymap = require("util.keymap")

local M = {
  -- delete buffer
  keymap.set_lazily("n", "<leader>bd", "<cmd>BufferClose<cr>", { desc = "Close buffer" }),
  keymap.set_lazily(
    "n",
    "<leader>bD",
    "<cmd>BufferClose!<cr>",
    { desc = "Close buffer forcibly!" }
  ),

  -- go to next/previous buffer
  keymap.set_lazily("n", "]b", "<cmd>BufferNext<cr>", { desc = "Go to next(right) buffer" }),
  keymap.set_lazily("n", "[b", "<cmd>BufferPrevious<cr>", { desc = "Go to previous(left) buffer" }),

  -- move/re-order buffer to next/previous position
  keymap.set_lazily(
    "n",
    "<leader>.",
    "<cmd>BufferMoveNext<cr>",
    { desc = "Move buffer to next(right)" }
  ),
  keymap.set_lazily(
    "n",
    "<leader>,",
    "<cmd>BufferMovePrevious<cr>",
    { desc = "Move buffer to previous(left)" }
  ),

  -- go to the last buffer
  keymap.set_lazily("n", "<leader>0", "<cmd>BufferLast<cr>", { desc = "Go to last buffer" }),
}

-- go to absolute buffer 1~9
for i = 1, 9 do
  table.insert(
    M,
    keymap.set_lazily(
      "n",
      string.format("<leader>%d", i),
      string.format("<cmd>BufferGoto %d<cr>", i),
      { desc = string.format("Go to %d buffer", i) }
    )
  )
end

return M
