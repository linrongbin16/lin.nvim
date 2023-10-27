local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    -- find files
    set_lazy_key(
        "n",
        "<space>f",
        "<cmd>FzfxFiles<cr>",
        { desc = "Find files" }
    ),
    set_lazy_key(
        "x",
        "<space>f",
        "<cmd>FzfxFilesV<cr>",
        { desc = "Find files" }
    ),
    -- find files by cursor word
    set_lazy_key(
        "n",
        "<space>wf",
        "<cmd>FzfxFilesW<cr>",
        { desc = "Find files by cursor word" }
    ),
    set_lazy_key(
        "n",
        "<space>pf",
        "<cmd>FzfxFilesP<cr>",
        { desc = "Find files by yank text" }
    ),
    -- search buffer
    set_lazy_key(
        "n",
        "<space>bf",
        "<cmd>FzfxBuffers<cr>",
        { desc = "Search buffers" }
    ),
    set_lazy_key(
        "x",
        "<space>bf",
        "<cmd>FzfxBuffersV<cr>",
        { desc = "Search buffers" }
    ),
    -- live grep
    set_lazy_key(
        "n",
        "<space>l",
        "<cmd>FzfxLiveGrep<cr>",
        { desc = "Live grep" }
    ),
    set_lazy_key(
        "x",
        "<space>l",
        "<cmd>FzfxLiveGrepV<cr>",
        { desc = "Live grep" }
    ),
    -- search word
    set_lazy_key(
        "n",
        "<space>wl",
        "<cmd>FzfxLiveGrepW<cr>",
        { desc = "Live grep by cursor word" }
    ),
    set_lazy_key(
        "n",
        "<space>pl",
        "<cmd>FzfxLiveGrepP<cr>",
        { desc = "Live grep by yank text" }
    ),
    -- git
    set_lazy_key(
        "n",
        "<space>gf",
        "<cmd>FzfxGFiles<cr>",
        { desc = "Search git files" }
    ),
    set_lazy_key(
        "n",
        "<space>br",
        "<cmd>FzfxGBranches<cr>",
        { desc = "Search git branches" }
    ),
    set_lazy_key(
        "n",
        "<space>gc",
        "<cmd>FzfxGCommits<cr>",
        { desc = "Search git commits" }
    ),
    -- vim commands
    set_lazy_key(
        "n",
        "<space>cm",
        "<cmd>FzfxCommands<cr>",
        { desc = "Search vim commands" }
    ),
    -- diagnostics
    set_lazy_key(
        "n",
        "<space>dg",
        "<cmd>FzfxLspDiagnostics<cr>",
        { desc = "Search lsp diagnostics" }
    ),
    set_lazy_key(
        "x",
        "<space>dg",
        "<cmd>FzfxLspDiagnosticsV<cr>",
        { desc = "Search lsp diagnostics" }
    ),
    -- file explorer
    set_lazy_key(
        "n",
        "<space>xp",
        "<cmd>FzfxFileExplorer<cr>",
        { desc = "File Explorer" }
    ),
}

return M
