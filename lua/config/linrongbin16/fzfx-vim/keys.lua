local keymap = require("builtin.utils.keymap")

local M = {
    -- find files
    keymap.set_lazy_key(
        "n",
        "<space>f",
        keymap.exec("FzfxFiles"),
        { desc = "Find files" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>f",
        keymap.exec(function()
            vim.cmd('execute "normal \\<ESC>"')
            vim.cmd("FzfxFilesV")
        end),
        { desc = "Find files" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>uf",
        keymap.exec("FzfxFilesU"),
        { desc = "Unrestricted find files" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>uf",
        keymap.exec(function()
            vim.cmd('execute "normal \\<ESC>"')
            vim.cmd("FzfxFilesUV")
        end),
        { desc = "Unrestricted find files" }
    ),
    -- find files by cursor word
    keymap.set_lazy_key(
        "n",
        "<space>wf",
        keymap.exec("FzfxFilesW"),
        { desc = "Find files by cursor word" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>uwf",
        keymap.exec("FzfxFilesUW"),
        { desc = "Unrestricted find files by cursor word" }
    ),
    -- search buffer
    keymap.set_lazy_key(
        "n",
        "<space>b",
        keymap.exec("FzfxBuffers"),
        { desc = "Search buffers" }
    ),
    -- live grep
    keymap.set_lazy_key(
        "n",
        "<space>l",
        keymap.exec("FzfxLiveGrep"),
        { desc = "Live grep" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>l",
        keymap.exec(function()
            vim.cmd('execute "normal \\<ESC>"')
            vim.cmd("FzfxLiveGrepV")
        end),
        { desc = "Live grep" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>ul",
        keymap.exec("FzfxLiveGrepU"),
        { desc = "Unrestricted live grep" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>ul",
        keymap.exec(function()
            vim.cmd('execute "normal \\<ESC>"')
            vim.cmd("FzfxLiveGrepUV")
        end),
        { desc = "Unrestricted live grep" }
    ),
    -- search word
    keymap.set_lazy_key(
        "n",
        "<space>wl",
        keymap.exec("FzfxLiveGrepW"),
        { desc = "Live grep by cursor word" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>uwl",
        keymap.exec("FzfxLiveGrepUW"),
        { desc = "Unrestricted live grep by cursor word" }
    ),
    -- git
    keymap.set_lazy_key(
        "n",
        "<space>gbr",
        keymap.exec("FzfxBranches"),
        { desc = "Search git branches" }
    ),
}

return M