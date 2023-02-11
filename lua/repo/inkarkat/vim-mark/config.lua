local map = require("conf/keymap").map

-- toggle mark under cursor in normal/visual mode
map("n", "<leader>km", "<Plug>MarkSet")
map("x", "<leader>km", "<Plug>MarkIWhiteSet")

-- search next/previous mark
map("n", "<leader>kn", "<Plug>MarkSearchNext")
map("n", "<leader>kN", "<Plug>MarkSearchPrev")

-- clear all marks with confirm
map("n", "<leader>kM", "<Plug>MarkAllClear")
