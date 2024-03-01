local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  -- go to the last buffer
  set_lazy_key(
    "n",
    "<leader>0",
    "<cmd>lua require('bufferline').go_to_buffer(-1, true)<cr>",
    { desc = "Go to the last buffer" }
  ),

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
}

-- go to absolute buffer 1~9
for i = 1, 9 do
  table.insert(
    M,
    set_lazy_key(
      "n",
      string.format("<leader>%d", i),
      string.format("<cmd>lua require('bufferline').go_to_buffer(%d, true)<cr>", i),
      { desc = string.format("Go to buffer-%d", i) }
    )
  )
end

return M
