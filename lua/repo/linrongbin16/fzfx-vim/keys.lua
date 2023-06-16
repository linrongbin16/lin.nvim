local keymap = require("cfg.keymap")

local M = {
    -- find files
    keymap.map_lazy(
        "n",
        "<space>f",
        keymap.exec("FzfxFiles"),
        { desc = "Find files" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec("FzfxUnrestrictedFiles"),
        { desc = "Unrestricted find files" }
    ),
    -- search buffer
    keymap.map_lazy(
        "n",
        "<space>b",
        keymap.exec("FzfxBuffers"),
        { desc = "Search buffers" }
    ),
    -- live grep
    keymap.map_lazy(
        { "n", "x" },
        "<space>l",
        keymap.exec("FzfxLiveGrep"),
        { desc = "Live grep" }
    ),
    keymap.map_lazy(
        { "n", "x" },
        "<space>ul",
        keymap.exec("FzfxUnrestrictedLiveGrep"),
        { desc = "Unrestricted live grep" }
    ),
    -- search word
    keymap.map_lazy(
        "n",
        "<space>w",
        keymap.exec("FzfxGrepWord"),
        { desc = "Grep word under cursor" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uw",
        keymap.exec("FzfxUnrestrictedGrepWord"),
        { desc = "Unrestricted grep word under cursor" }
    ),
    -- git
    keymap.map_lazy(
        "n",
        "<space>gbr",
        keymap.exec("FzfxBranches"),
        { desc = "Search git branches" }
    ),
}

return M