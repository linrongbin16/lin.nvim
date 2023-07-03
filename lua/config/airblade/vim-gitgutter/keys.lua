local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "]c",
        "<Plug>(GitGutterNextHunk)",
        { desc = "Go to next git hunk" }
    ),
    map_lazy(
        "n",
        "[c",
        "<Plug>(GitGutterPrevHunk)",
        { desc = "Go to previous git hunk" }
    ),
}

return M