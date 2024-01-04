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
        "<cmd>FzfxFiles visual<cr>",
        { desc = "Find files" }
    ),
    set_lazy_key(
        "n",
        "<space>wf",
        "<cmd>FzfxFiles cword<cr>",
        { desc = "Find files by cursor word" }
    ),
    set_lazy_key(
        "n",
        "<space>pf",
        "<cmd>FzfxFiles put<cr>",
        { desc = "Find files by yank text" }
    ),
    set_lazy_key(
        "n",
        "<space>rf",
        "<cmd>FzfxFiles resume<cr>",
        { desc = "Find files by resume last" }
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
        "<cmd>FzfxLiveGrep visual<cr>",
        { desc = "Live grep" }
    ),
    set_lazy_key(
        "n",
        "<space>wl",
        "<cmd>FzfxLiveGrep cword<cr>",
        { desc = "Live grep by cursor word" }
    ),
    set_lazy_key(
        "n",
        "<space>pl",
        "<cmd>FzfxLiveGrep put<cr>",
        { desc = "Live grep by yank text" }
    ),
    set_lazy_key(
        "n",
        "<space>rl",
        "<cmd>FzfxLiveGrep resume<cr>",
        { desc = "Live grep by resume last" }
    ),
    -- git
    set_lazy_key(
        "n",
        "<space>gr",
        "<cmd>FzfxGLiveGrep<cr>",
        { desc = "Git grep" }
    ),
    set_lazy_key(
        "x",
        "<space>gr",
        "<cmd>FzfxGLiveGrep visual<cr>",
        { desc = "Git grep" }
    ),
    set_lazy_key(
        "n",
        "<space>wgr",
        "<cmd>FzfxGLiveGrep cword<cr>",
        { desc = "Git grep by cursor word" }
    ),
    set_lazy_key(
        "n",
        "<space>pgr",
        "<cmd>FzfxGLiveGrep put<cr>",
        { desc = "Git grep by yank text" }
    ),
    set_lazy_key(
        "n",
        "<space>rgr",
        "<cmd>FzfxGLiveGrep resume<cr>",
        { desc = "Git grep by resume last" }
    ),
    set_lazy_key(
        "n",
        "<space>gf",
        "<cmd>FzfxGFiles<cr>",
        { desc = "Search git files" }
    ),
    set_lazy_key(
        "n",
        "<space>gs",
        "<cmd>FzfxGStatus<cr>",
        { desc = "Search changed git files (status)" }
    ),
    set_lazy_key(
        "n",
        "<space>gb",
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
        "<cmd>FzfxLspDiagnostics visual<cr>",
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
