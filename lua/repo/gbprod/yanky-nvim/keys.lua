local keymap = require("cfg.keymap")

local M = {
    -- put
    keymap.map_lazy(
        { "n", "x" },
        "p",
        "<Plug>(YankyPutAfter)",
        { desc = "Put after cursor (yanky)" }
    ),
    keymap.map_lazy(
        { "n", "x" },
        "P",
        "<Plug>(YankyPutBefore)",
        { desc = "Put before cursor (yanky)" }
    ),
    keymap.map_lazy(
        { "n", "x" },
        "gp",
        "<Plug>(YankyGPutAfter)",
        { desc = "Put after cursor and leave the cursor after (yanky)" }
    ),
    keymap.map_lazy(
        { "n", "x" },
        "gP",
        "<Plug>(YankyGPutBefore)",
        { desc = "Put before cursor and leave the cursor after (yanky)" }
    ),
    -- yank
    keymap.map_lazy(
        { "n", "x" },
        "y",
        "<Plug>(YankyYank)",
        { desc = "Yank (yanky)" }
    ),
}

return M