local keymap = require("cfg.keymap")

local M = {
    -- search files
    keymap.map_lazy(
        "n",
        "<space>f",
        keymap.exec("FzfFiles"),
        { desc = "Search files(Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec("FzfUnrestrictedFiles"),
        { desc = "Unrestricted search files(Fzf)" }
    ),
    -- search buffer
    keymap.map_lazy(
        "n",
        "<space>b",
        keymap.exec("FzfBuffers"),
        { desc = "Search buffers(Fzf)" }
    ),
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>l",
        keymap.exec("FzfLiveGrep"),
        { desc = "Live grep(Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ul",
        keymap.exec("FzfUnrestrictedLiveGrep"),
        { desc = "Unrestricted live grep(Fzf)" }
    ),
    -- search word
    keymap.map_lazy(
        "n",
        "<space>w",
        keymap.exec("FzfCWord"),
        { desc = "Search word under cursor(Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uw",
        keymap.exec("FzfUnrestrictedCWord"),
        { desc = "Unrestricted search word under cursor(Fzf)" }
    ),
}

return M