local keymap = require("builtin.utils.keymap")

local M = {
    -- search git
    keymap.set_lazy_key(
        "n",
        "<space>gs",
        keymap.exec("FzfGFiles?"),
        { desc = "Search git status" }
    ),
    -- search vim
    keymap.set_lazy_key(
        "n",
        "<space>tg",
        keymap.exec("FzfTags"),
        { desc = "Search vim tags" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>ch",
        keymap.exec("FzfHistory:"),
        { desc = "Search vim command history" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>sh",
        keymap.exec("FzfHistory/"),
        { desc = "Search vim search history" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>mk",
        keymap.exec("FzfMarks"),
        { desc = "Search vim marks" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>km",
        keymap.exec("FzfMaps"),
        { desc = "Search vim keymaps" }
    ),
}

return M