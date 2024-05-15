local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  -- go to next/previous buffer
  set_lazy_key("n", "]b", "<cmd>BufferNext<cr>", { desc = "Go to next(right) buffer" }),
  set_lazy_key("n", "[b", "<cmd>BufferPrevious<cr>", { desc = "Go to previous(left) buffer" }),

  -- move/re-order buffer to next/previous position
  set_lazy_key(
    "n",
    "<leader>.",
    "<cmd>BufferMoveNext<cr>",
    { desc = "Move buffer to next(right)" }
  ),
  set_lazy_key(
    "n",
    "<leader>,",
    "<cmd>BufferMovePrevious<cr>",
    { desc = "Move buffer to previous(left)" }
  ),

  -- delete current buffer
  set_lazy_key("n", "<leader>bd", "<cmd>BufferClose<cr>", { desc = "Close current buffer" }),
  set_lazy_key(
    "n",
    "<leader>bD",
    "<cmd>BufferClose!<cr>",
    { desc = "Close current buffer forcibly!" }
  ),

  -- go to the last buffer
  set_lazy_key("n", "<leader>0", "<cmd>BufferLast<cr>", { desc = "Go to last buffer" }),
}

-- go to absolute buffer 1~9
for i = 1, 9 do
  table.insert(
    M,
    set_lazy_key(
      "n",
      string.format("<leader>%d", i),
      string.format("<cmd>BufferGoto %d<cr>", i),
      { desc = string.format("Go to %d buffer", i) }
    )
  )
end

return M
