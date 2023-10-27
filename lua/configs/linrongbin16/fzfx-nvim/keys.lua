local keymap = require("builtin.utils.keymap")

local M = {
    -- find files
    keymap.set_lazy_key(
        "n",
        "<space>f",
        "<cmd>FzfxFiles<cr>",
        { desc = "Find files" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>f",
        "<cmd>FzfxFilesV<cr>",
        { desc = "Find files" }
    ),
    -- find files by cursor word
    keymap.set_lazy_key(
        "n",
        "<space>wf",
        "<cmd>FzfxFilesW<cr>",
        { desc = "Find files by cursor word" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>pf",
        "<cmd>FzfxFilesP<cr>",
        { desc = "Find files by yank text" }
    ),
    -- search buffer
    keymap.set_lazy_key(
        "n",
        "<space>bf",
        "<cmd>FzfxBuffers<cr>",
        { desc = "Search buffers" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>bf",
        "<cmd>FzfxBuffersV<cr>",
        { desc = "Search buffers" }
    ),
    -- live grep
    keymap.set_lazy_key(
        "n",
        "<space>l",
        "<cmd>FzfxLiveGrep<cr>",
        { desc = "Live grep" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>l",
        "<cmd>FzfxLiveGrepV<cr>",
        { desc = "Live grep" }
    ),
    -- search word
    keymap.set_lazy_key(
        "n",
        "<space>wl",
        "<cmd>FzfxLiveGrepW<cr>",
        { desc = "Live grep by cursor word" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>pl",
        "<cmd>FzfxLiveGrepP<cr>",
        { desc = "Live grep by yank text" }
    ),
    -- git
    keymap.set_lazy_key(
        "n",
        "<space>gf",
        "<cmd>FzfxGFiles<cr>",
        { desc = "Search git files" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>br",
        "<cmd>FzfxGBranches<cr>",
        { desc = "Search git branches" }
    ),
    keymap.set_lazy_key(
        "n",
        "<space>gc",
        "<cmd>FzfxGCommits<cr>",
        { desc = "Search git commits" }
    ),
    -- vim commands
    keymap.set_lazy_key(
        "n",
        "<space>cm",
        "<cmd>FzfxCommands<cr>",
        { desc = "Search vim commands" }
    ),
    -- diagnostics
    keymap.set_lazy_key(
        "n",
        "<space>dg",
        "<cmd>FzfxLspDiagnostics<cr>",
        { desc = "Search lsp diagnostics" }
    ),
    keymap.set_lazy_key(
        "x",
        "<space>dg",
        "<cmd>FzfxLspDiagnosticsV<cr>",
        { desc = "Search lsp diagnostics" }
    ),
    -- file explorer
    keymap.set_lazy_key(
        "n",
        "<space>xp",
        "<cmd>FzfxFileExplorer<cr>",
        { desc = "File Explorer" }
    ),
}

return M
