local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "]c",
        "<Plug>(GitGutterNextHunk)",
        { desc = "Next git hunk" }
    ),
    map_lazy(
        "n",
        "[c",
        "<Plug>(GitGutterPrevHunk)",
        { desc = "Previous git hunk" }
    ),
}

return M
