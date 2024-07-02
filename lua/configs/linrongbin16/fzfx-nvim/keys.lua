local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  -- find files
  set_lazy_key("n", "<space>f", "<cmd>FzfxFiles<cr>", { desc = "Find files" }),
  set_lazy_key("x", "<space>f", "<cmd>FzfxFiles visual<cr>", { desc = "Find files" }),
  set_lazy_key(
    "n",
    "<space>wf",
    "<cmd>FzfxFiles cword<cr>",
    { desc = "Find files by cursor word" }
  ),
  set_lazy_key("n", "<space>pf", "<cmd>FzfxFiles put<cr>", { desc = "Find files by yank text" }),
  set_lazy_key(
    "n",
    "<space>rf",
    "<cmd>FzfxFiles resume<cr>",
    { desc = "Find files by resume last" }
  ),
  -- find git files
  set_lazy_key("n", "<space>gf", "<cmd>FzfxGFiles<cr>", { desc = "Search git files" }),
  set_lazy_key("x", "<space>gf", "<cmd>FzfxGFiles visual<cr>", { desc = "Search git files" }),
  -- search buffers
  set_lazy_key("n", "<space>bf", "<cmd>FzfxBuffers<cr>", { desc = "Search buffers" }),
  set_lazy_key("x", "<space>bf", "<cmd>FzfxBuffers visual<cr>", { desc = "Search buffers" }),
  -- live grep
  set_lazy_key("n", "<space>l", "<cmd>FzfxLiveGrep<cr>", { desc = "Live grep" }),
  set_lazy_key("x", "<space>l", "<cmd>FzfxLiveGrep visual<cr>", { desc = "Live grep" }),
  set_lazy_key(
    "n",
    "<space>wl",
    "<cmd>FzfxLiveGrep cword<cr>",
    { desc = "Live grep by cursor word" }
  ),
  set_lazy_key("n", "<space>pl", "<cmd>FzfxLiveGrep put<cr>", { desc = "Live grep by yank text" }),
  set_lazy_key(
    "n",
    "<space>rl",
    "<cmd>FzfxLiveGrep resume<cr>",
    { desc = "Live grep by resume last" }
  ),
  -- git live grep
  set_lazy_key("n", "<space>gr", "<cmd>FzfxGLiveGrep<cr>", { desc = "Git grep" }),
  set_lazy_key("x", "<space>gr", "<cmd>FzfxGLiveGrep visual<cr>", { desc = "Git grep" }),
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
}

return M
