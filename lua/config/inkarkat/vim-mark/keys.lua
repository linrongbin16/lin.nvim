local map_lazy = require("cfg.keymap").map_lazy

local M = {
    -- toggle cursor word in normal/visual mode
    map_lazy(
        "n",
        "<leader>hw",
        "<Plug>MarkSet",
        { desc = "Toggle highlight word" }
    ),
    map_lazy(
        "x",
        "<leader>hw",
        "<Plug>MarkIWhiteSet",
        { desc = "Toggle highlight word" }
    ),

    -- search next/previous word
    map_lazy(
        "n",
        "<leader>hn",
        "<Plug>MarkSearchNext",
        { desc = "Next highlight word" }
    ),
    map_lazy(
        "n",
        "<leader>hN",
        "<Plug>MarkSearchPrev",
        { desc = "Previous highlight word" }
    ),

    -- clear all words
    map_lazy(
        "n",
        "<leader>hW",
        "<Plug>MarkAllClear",
        { desc = "Clear all highlight words" }
    ),
}

return M
