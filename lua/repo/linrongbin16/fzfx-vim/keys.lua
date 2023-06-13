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
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>l",
        keymap.exec("FzfxLiveGrep"),
        { desc = "Live grep" }
    ),
    keymap.map_lazy(
        "n",
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
}

return M