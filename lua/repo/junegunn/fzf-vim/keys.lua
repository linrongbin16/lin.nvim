local keymap = require("cfg.keymap")

local M = {
    -- search files
    keymap.map_lazy(
        "n",
        "<space>f",
        keymap.exec("FzfFiles"),
        { desc = "Search files" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec("FzfUnrestrictedFiles"),
        { desc = "Unrestricted search files" }
    ),
    -- search buffer
    keymap.map_lazy(
        "n",
        "<space>b",
        keymap.exec("FzfBuffers"),
        { desc = "Search buffers" }
    ),
    -- live grep
    keymap.map_lazy(
        "n",
        "<space>l",
        keymap.exec("FzfLiveGrep"),
        { desc = "Live grep with `--iglob` support" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ul",
        keymap.exec("FzfUnrestrictedLiveGrep"),
        { desc = "Unrestricted live grep with `--iglob` support" }
    ),
    keymap.map_lazy(
        "n",
        "<space>r",
        keymap.exec("FzfLiveGrepNoGlob"),
        { desc = "Live grep (without `--iglob` support)" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ur",
        keymap.exec("FzfUnrestrictedLiveGrepNoGlob"),
        { desc = "Unrestricted live grep (without `--iglob` support)" }
    ),
    -- search word
    keymap.map_lazy(
        "n",
        "<space>w",
        keymap.exec("FzfCWord"),
        { desc = "Search word under cursor" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uw",
        keymap.exec("FzfUnrestrictedCWord"),
        { desc = "Unrestricted search word under cursor" }
    ),
    -- search WORD
    keymap.map_lazy(
        "n",
        "<space>W",
        keymap.exec("FzfCapitalizedCWORD"),
        { desc = "Search WORD under cursor" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uw",
        keymap.exec("FzfUnrestrictedCapitalizedCWORD"),
        { desc = "Unrestricted search WORD under cursor" }
    ),
    -- search git
    keymap.map_lazy(
        "n",
        "<space>gf",
        keymap.exec("FzfGFiles"),
        { desc = "Search git files" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gb",
        keymap.exec("FzfGBranches"),
        { desc = "Search git branches" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gc",
        keymap.exec("FzfCommits"),
        { desc = "Search git commits" }
    ),
    keymap.map_lazy(
        "n",
        "<space>gs",
        keymap.exec("FzfGFiles?"),
        { desc = "Search git status" }
    ),
    -- search vim
    keymap.map_lazy(
        "n",
        "<space>cm",
        keymap.exec("FzfCommands"),
        { desc = "Search vim commands" }
    ),
    keymap.map_lazy(
        "n",
        "<space>tg",
        keymap.exec("FzfTags"),
        { desc = "Search vim tags" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ch",
        keymap.exec("FzfHistory:"),
        { desc = "Search vim command history" }
    ),
    keymap.map_lazy(
        "n",
        "<space>sh",
        keymap.exec("FzfHistory/"),
        { desc = "Search vim search history" }
    ),
    keymap.map_lazy(
        "n",
        "<space>mk",
        keymap.exec("FzfMarks"),
        { desc = "Search vim marks" }
    ),
    keymap.map_lazy(
        "n",
        "<space>km",
        keymap.exec("FzfMaps"),
        { desc = "Search vim keymaps" }
    ),
}

return M