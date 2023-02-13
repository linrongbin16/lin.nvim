local map = require("conf/keymap").map

-- toggle mark under cursor in normal/visual mode
map("n", "<leader>km", "<Plug>MarkSet", { desc = "Toggle highlight word" })
map("x", "<leader>km", "<Plug>MarkIWhiteSet", { desc = "Toggle highlight word" })

-- search next/previous mark
map("n", "<leader>kn", "<Plug>MarkSearchNext", { desc = "Next highlight word" })
map("n", "<leader>kN", "<Plug>MarkSearchPrev", { desc = "Previous highlight word" })

-- clear all marks with confirm
map("n", "<leader>kM", "<Plug>MarkAllClear", { desc = "Clear all highlight words" })
