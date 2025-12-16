local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local function get_visual()
  return table.concat(
    vim.fn.getregion(
      vim.fn.getpos("."),
      vim.fn.getpos("v"),
      { type = vim.api.nvim_get_mode().mode }
    )
  )
end

local M = {
  -- find files
  set_lazy_key("n", "<space>f", function()
    require("fzf-lua").files()
  end, { desc = "Find files" }),
  set_lazy_key("x", "<space>f", function()
    local selection = get_visual()
    require("fzf-lua").files({ query = selection })
  end, { desc = "Find files" }),
  set_lazy_key("n", "<space>wf", function()
    local cword = vim.fn.expand("<cword>")
    require("fzf-lua").files({ query = cword })
  end, { desc = "Find files by cword" }),
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
}

return M
