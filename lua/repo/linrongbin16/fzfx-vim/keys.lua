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
        "x",
        "<space>f",
        keymap.exec("FzfxFilesV"),
        { desc = "Find files" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uf",
        keymap.exec("FzfxFilesU"),
        { desc = "Unrestricted find files" }
    ),
    keymap.map_lazy(
        "x",
        "<space>uf",
        keymap.exec("FzfxFilesUV"),
        { desc = "Unrestricted find files" }
    ),
    -- find files by cursor word
    keymap.map_lazy(
        "n",
        "<space>wf",
        keymap.exec("FzfxFilesW"),
        { desc = "Find files by cursor word" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uwf",
        keymap.exec("FzfxFilesUW"),
        { desc = "Unrestricted find files by cursor word" }
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
        "n",
        "<space>l",
        keymap.exec("FzfxLiveGrep"),
        { desc = "Live grep" }
    ),
    keymap.map_lazy(
        "x",
        "<space>l",
        keymap.exec(function()
            vim.cmd('execute "normal \\<ESC>"')
            vim.cmd("FzfxLiveGrepV")
        end),
        { desc = "Live grep" }
    ),
    keymap.map_lazy(
        "n",
        "<space>ul",
        keymap.exec("FzfxLiveGrepU"),
        { desc = "Unrestricted live grep" }
    ),
    keymap.map_lazy(
        "x",
        "<space>ul",
        keymap.exec(function()
            vim.cmd('execute "normal \\<ESC>"')
            vim.cmd("FzfxLiveGrepUV")
        end),
        { desc = "Unrestricted live grep" }
    ),
    -- search word
    keymap.map_lazy(
        "n",
        "<space>wl",
        keymap.exec("FzfxLiveGrepW"),
        { desc = "Live grep by cursor word" }
    ),
    keymap.map_lazy(
        "n",
        "<space>uwl",
        keymap.exec("FzfxLiveGrepUW"),
        { desc = "Unrestricted live grep by cursor word" }
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