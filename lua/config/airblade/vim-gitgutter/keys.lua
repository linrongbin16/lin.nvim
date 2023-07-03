local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "]c",
        "<Plug>(GitGutterNextHunk)",
        { desc = "Go to next git hunk" }
    ),
    set_lazy_key(
        "n",
        "[c",
        "<Plug>(GitGutterPrevHunk)",
        { desc = "Go to previous git hunk" }
    ),
}

return M