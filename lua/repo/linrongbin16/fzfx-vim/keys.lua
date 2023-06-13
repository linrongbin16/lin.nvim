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
    -- find files by word under cursor
    keymap.map_lazy(
        "n",
        "<space>wf",
        keymap.exec("FzfxFilesByWord"),
        { desc = "Find files by word under cursor" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uwf",
        keymap.exec("FzfxUnrestrictedFilesByWord"),
        { desc = "Unrestricted find files by word under cursor" }
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
        "<space>wd",
        keymap.exec("FzfxGrepWord"),
        { desc = "Grep word under cursor" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uwd",
        keymap.exec("FzfxUnrestrictedGrepWord"),
        { desc = "Unrestricted grep word under cursor" }
    ),
}

return M