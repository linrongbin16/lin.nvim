require("bufferline").setup({
  options = {
    numbers = function(opts)
        return string.format("%s.%s", opts.ordinal, opts.lower(opts.id))
    end,
    -- numbers = "ordinal",
    close_command = "Bdelete! %d", -- Bdelete: https://github.com/moll/vim-bbye
    right_mouse_command = "Bdelete! %d",
    max_name_length = 60,
    max_prefix_length = 55,
    diagnostics = false,
    separator_style = "slant",
    hover = {
      enabled = false,
    },
  },
})

-- key maps
local keymap = require("conf/keymap")

-- go to absolute buffer 1~9, and 0
for i = 1, 9 do
  keymap.map(
    "n",
    string.format("<leader>%d", i),
    keymap.exec(
      string.format("require('bufferline').go_to_buffer(%d, true)", i)
    ),
    { desc = string.format("Go to buffer-%d", i) }
  )
end
keymap.map(
  "n",
  "<leader>0",
  keymap.exec("require('bufferline').go_to_buffer(-1, true)"),
  { desc = "Go to the last buffer" }
)

-- go to next/previous buffer
keymap.map(
  "n",
  "]b",
  keymap.exec("BufferLineCycleNext"),
  { desc = "Go to next buffer" }
)
keymap.map(
  "n",
  "[b",
  keymap.exec("BufferLineCyclePrev"),
  { desc = "Go to previous buffer" }
)

-- close buffer
keymap.map("n", "<leader>bd", keymap.exec("Bdelete"), { desc = "Close buffer" })
keymap.map(
  "n",
  "<leader>bD",
  keymap.exec("Bdelete!"),
  { desc = "Close buffer forcibly!" }
)

-- re-order/move current buffer to next/previous position
keymap.map(
  "n",
  "<leader>.",
  keymap.exec("BufferLineMoveNext"),
  { desc = "Move buffer to next" }
)
keymap.map(
  "n",
  "<leader>,",
  keymap.exec("BufferLineMovePrev"),
  { desc = "Move buffer to previous" }
)
