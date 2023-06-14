local keymap = require("cfg.keymap")

local M = {
    -- search buffer
    keymap.map_lazy(
        "n",
        "<space>b",
        keymap.exec("FzfBuffers"),
        { desc = "Search buffers" }
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