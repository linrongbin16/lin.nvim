local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  -- go to next/previous buffer
  set_lazy_key("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Go to next buffer" }),
  set_lazy_key("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Go to previous buffer" }),

  -- move/re-order buffer to next/previous position
  set_lazy_key("n", "<leader>.", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer to next" }),
  set_lazy_key(
    "n",
    "<leader>,",
    "<cmd>BufferLineMovePrev<cr>",
    { desc = "Move buffer to previous" }
  ),

  -- go to the last buffer
  set_lazy_key(
    "n",
    "<leader>0",
    "<cmd>lua require('bufferline').go_to(-1, true)<cr>",
    { desc = "Go to last buffer" }
  ),
}

-- go to absolute buffer 1~9
for i = 1, 9 do
  table.insert(
    M,
    set_lazy_key(
      "n",
      string.format("<leader>%d", i),
      string.format("<cmd>lua require('bufferline').go_to(%d, true)<cr>", i),
      { desc = string.format("Go to %d buffer", i) }
    )
  )
end

return M
