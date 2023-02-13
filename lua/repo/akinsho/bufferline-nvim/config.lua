require("bufferline").setup({
  options = {
    -- numbers = function(opts)
    --     return string.format("%s.%s", opts.ordinal, opts.lower(opts.id))
    -- end,
    numbers = "ordinal",
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

-- go to absolute buffer
keymap.map(
  "n",
  "<leader>1",
  keymap.exec("require('bufferline').go_to_buffer(1, true)"),
  { desc = "Go to buffer-1" }
)
keymap.map(
  "n",
  "<leader>2",
  keymap.exec("require('bufferline').go_to_buffer(2, true)"),
  { desc = "Go to buffer-2" }
)
keymap.map(
  "n",
  "<leader>3",
  keymap.exec("require('bufferline').go_to_buffer(3, true)"),
  { desc = "Go to buffer-3" }
)
keymap.map(
  "n",
  "<leader>4",
  keymap.exec("require('bufferline').go_to_buffer(4, true)"),
  { desc = "Go to buffer-4" }
)
keymap.map(
  "n",
  "<leader>5",
  keymap.exec("require('bufferline').go_to_buffer(5, true)"),
  { desc = "Go to buffer-5" }
)
keymap.map(
  "n",
  "<leader>6",
  keymap.exec("require('bufferline').go_to_buffer(6, true)"),
  { desc = "Go to buffer-6" }
)
keymap.map(
  "n",
  "<leader>7",
  keymap.exec("require('bufferline').go_to_buffer(7, true)"),
  { desc = "Go to buffer-7" }
)
keymap.map(
  "n",
  "<leader>8",
  keymap.exec("require('bufferline').go_to_buffer(8, true)"),
  { desc = "Go to buffer-8" }
)
keymap.map(
  "n",
  "<leader>9",
  keymap.exec("require('bufferline').go_to_buffer(9, true)"),
  { desc = "Go to buffer-9" }
)
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
  "<leader>>",
  keymap.exec("BufferLineMoveNext"),
  { desc = "Move buffer to next" }
)
keymap.map(
  "n",
  "<leader><",
  keymap.exec("BufferLineMovePrev"),
  { desc = "Move buffer to previous" }
)
