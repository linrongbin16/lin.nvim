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
        keymap.exec("FzfxFilesV"),
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
        keymap.exec("FzfxFilesUV"),
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
    keymap.set_lazy_key(
        "n",
        "<space>pf",
        keymap.exec("FzfxFilesP"),
        { desc = "Find files by yank text" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>upf",
        keymap.exec("FzfxFilesUP"),
        { desc = "Unrestricted find files by yank text" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>rf",
        keymap.exec("FzfxResumeFiles"),
        { desc = "Resume last files search" }
    ),
    -- search buffer
    keymap.set_lazy_key(
        "n",
        "<space>bf",
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
        keymap.exec("FzfxLiveGrepV"),
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
        keymap.exec("FzfxLiveGrepUV"),
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
    keymap.set_lazy_key(
        "n",
        "<space>pl",
        keymap.exec("FzfxLiveGrepP"),
        { desc = "Live grep by yank text" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>upl",
        keymap.exec("FzfxLiveGrepUP"),
        { desc = "Unrestricted live grep by yank text" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>rl",
        keymap.exec("FzfxResumeLiveGrep"),
        { desc = "Resume last live grep" }
    ),
    -- git
    keymap.set_lazy_key(
        "n",
        "<space>gf",
        keymap.exec("FzfxGFiles"),
        { desc = "Search git files" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>br",
        keymap.exec("FzfxGBranches"),
        { desc = "Search git branches" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>gc",
        keymap.exec("FzfxGCommits"),
        { desc = "Search git commits" }
    ),
    -- vim
    keymap.set_lazy_key(
        "n",
        "<space>cm",
        keymap.exec("FzfxCommands"),
        { desc = "Search vim commands" }
    ),
}

return M