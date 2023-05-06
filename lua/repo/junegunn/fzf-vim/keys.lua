local keymap = require("cfg.keymap")

local M = {
    -- search files
    keymap.map_lazy(
        "n",
        "<space>f",
        keymap.exec("FzfFiles"),
        { desc = "Search files (Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec("FzfUnrestrictedFiles"),
        { desc = "Unrestricted search files (Fzf)" }
    ),
    -- search buffer
    keymap.map_lazy(
        "n",
        "<space>b",
        keymap.exec("FzfBuffers"),
        { desc = "Search buffers (Fzf)" }
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
    -- search git
    keymap.map_lazy(
        "n",
        "<space>gf",
        keymap.exec("FzfGFiles"),
        { desc = "Search git files (Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gc",
        keymap.exec("FzfCommits"),
        { desc = "Search git commits (Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gs",
        keymap.exec("FzfGFiles?"),
        { desc = "Search git status (Fzf)" }
    ),
    -- search vim
    keymap.map_lazy(
        "n",
        "<space>cm",
        keymap.exec("FzfCommands"),
        { desc = "Search vim commands (Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>tg",
        keymap.exec("FzfTags"),
        { desc = "Search vim tags (Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ch",
        keymap.exec("FzfHistory:"),
        { desc = "Search vim command history (Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>sh",
        keymap.exec("FzfHistory/"),
        { desc = "Search vim search history (Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>mk",
        keymap.exec("FzfMarks"),
        { desc = "Search vim marks (Fzf)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>km",
        keymap.exec("FzfMaps"),
        { desc = "Search vim keymaps (Fzf)" }
    ),
    -- yanky
    keymap.map_lazy(
        "n",
        "<space>yh",
        keymap.exec("YankyRingHistory"),
        { desc = "Search yanky ring history (Fzf)" }
    ),
}

return M