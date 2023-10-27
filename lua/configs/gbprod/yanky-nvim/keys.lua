local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    -- put
    set_lazy_key(
        { "n", "x" },
        "p",
        "<Plug>(YankyPutAfter)",
        { desc = "Put after cursor (yanky)" }
    ),
    set_lazy_key(
        { "n", "x" },
        "P",
        "<Plug>(YankyPutBefore)",
        { desc = "Put before cursor (yanky)" }
    ),
    set_lazy_key(
        { "n", "x" },
        "gp",
        "<Plug>(YankyGPutAfter)",
        { desc = "Put after cursor and leave the cursor after (yanky)" }
    ),
    set_lazy_key(
        { "n", "x" },
        "gP",
        "<Plug>(YankyGPutBefore)",
        { desc = "Put before cursor and leave the cursor after (yanky)" }
    ),
    -- yank
    set_lazy_key(
        { "n", "x" },
        "y",
        "<Plug>(YankyYank)",
        { desc = "Yank (yanky)" }
    ),
}

return M
