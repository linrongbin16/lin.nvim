local map = require("conf/keymap").map

-- toggle cursor word in normal/visual mode
map("n", "<leader>hw", "<Plug>MarkSet", { desc = "Toggle highlight word" })
map(
    "x",
    "<leader>hw",
    "<Plug>MarkIWhiteSet",
    { desc = "Toggle highlight word" }
)

-- search next/previous word
map("n", "<leader>hn", "<Plug>MarkSearchNext", { desc = "Next highlight word" })
map(
    "n",
    "<leader>hN",
    "<Plug>MarkSearchPrev",
    { desc = "Previous highlight word" }
)

-- clear all words
map(
    "n",
    "<leader>hW",
    "<Plug>MarkAllClear",
    { desc = "Clear all highlight words" }
)
