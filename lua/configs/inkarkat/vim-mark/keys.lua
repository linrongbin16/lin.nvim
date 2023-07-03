local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    -- toggle cursor word in normal/visual mode
    set_lazy_key(
        "n",
        "<leader>hw",
        "<Plug>MarkSet",
        { desc = "Toggle highlight word" }
    ),
    set_lazy_key(
        "x",
        "<leader>hw",
        "<Plug>MarkIWhiteSet",
        { desc = "Toggle highlight word" }
    ),

    -- search next/previous word
    set_lazy_key(
        "n",
        "<leader>hn",
        "<Plug>MarkSearchNext",
        { desc = "Next highlight word" }
    ),
    set_lazy_key(
        "n",
        "<leader>hN",
        "<Plug>MarkSearchPrev",
        { desc = "Previous highlight word" }
    ),

    -- clear all words
    set_lazy_key(
        "n",
        "<leader>hW",
        "<Plug>MarkAllClear",
        { desc = "Clear all highlight words" }
    ),
}

return M