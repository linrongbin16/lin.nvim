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
    -- find files by cursor word
    keymap.set_lazy_key(
        "n",
        "<space>wf",
        keymap.exec("FzfxFilesW"),
        { desc = "Find files by cursor word" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>pf",
        keymap.exec("FzfxFilesP"),
        { desc = "Find files by yank text" }
    ),
    -- search buffer
    keymap.set_lazy_key(
        "n",
        "<space>bf",
        keymap.exec("FzfxBuffers"),
        { desc = "Search buffers" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>bf",
        keymap.exec("FzfxBuffersV"),
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
    -- search word
    keymap.set_lazy_key(
        "n",
        "<space>wl",
        keymap.exec("FzfxLiveGrepW"),
        { desc = "Live grep by cursor word" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>pl",
        keymap.exec("FzfxLiveGrepP"),
        { desc = "Live grep by yank text" }
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
    -- diagnostics
    keymap.set_lazy_key(
        "n",
        "<space>dg",
        keymap.exec("FzfxLspDiagnostics"),
        { desc = "Search lsp diagnostics" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>dg",
        keymap.exec("FzfxLspDiagnosticsV"),
        { desc = "Search lsp diagnostics" }
    ),
}

return M
