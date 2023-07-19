local keymap = require("builtin.utils.keymap")

local M = {
    -- put
    keymap.set_lazy_key(
        { "n", "x" },
        "p",
        "<Plug>(YankyPutAfter)",
        { desc = "Put after cursor (yanky)" }
    ),
    keymap.set_lazy_key(
        { "n", "x" },
        "P",
        "<Plug>(YankyPutBefore)",
        { desc = "Put before cursor (yanky)" }
    ),
    keymap.set_lazy_key(
        { "n", "x" },
        "gp",
        "<Plug>(YankyGPutAfter)",
        { desc = "Put after cursor and leave the cursor after (yanky)" }
    ),
    keymap.set_lazy_key(
        { "n", "x" },
        "gP",
        "<Plug>(YankyGPutBefore)",
        { desc = "Put before cursor and leave the cursor after (yanky)" }
    ),
    -- yank
    keymap.set_lazy_key(
        { "n", "x" },
        "y",
        "<Plug>(YankyYank)",
        { desc = "Yank (yanky)" }
    ),
    -- history
    keymap.set_lazy_key(
        "n",
        "<leader>yh",
        keymap.exec("YankyRingHistory"),
        { desc = "Yank ring history" }
    ),
}

return M