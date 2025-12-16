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
  set_lazy_key("n", "<space>pf", "<cmd>FzfxFiles put<cr>", { desc = "Find files by yank" }),
  set_lazy_key("n", "<space>rf", function()
    require("fzf-lua").files({ resume = true })
  end, { desc = "Find files by resume" }),

  -- find git files
  set_lazy_key("n", "<space>gf", function()
    require("fzf-lua").git_files()
  end, { desc = "Search git files" }),
  set_lazy_key("x", "<space>gf", function()
    local selection = get_visual()
    require("fzf-lua").git_files({ query = selection })
  end, { desc = "Search git files" }),

  -- search buffers
  set_lazy_key("n", "<space>bf", function()
    require("fzf-lua").buffers()
  end, { desc = "Search buffers" }),
  set_lazy_key("x", "<space>bf", function()
    local selection = get_visual()
    require("fzf-lua").buffers({ query = selection })
  end, { desc = "Search buffers" }),

  -- live grep
  set_lazy_key("n", "<space>l", function()
    require("fzf-lua").live_grep()
  end, { desc = "Live grep" }),
  set_lazy_key("x", "<space>l", function()
    local selection = get_visual()
    require("fzf-lua").live_grep({ query = selection })
  end, { desc = "Live grep" }),
  set_lazy_key("n", "<space>wl", function()
    local cword = vim.fn.expand("<cword>")
    require("fzf-lua").live_grep({ query = cword })
  end, { desc = "Live grep by cword" }),
  set_lazy_key("n", "<space>pl", "<cmd>FzfxLiveGrep put<cr>", { desc = "Live grep by yank" }),
  set_lazy_key("n", "<space>rl", function()
    require("fzf-lua").live_grep({ resume = true })
  end, { desc = "Live grep by resume " }),

  -- git live grep
  set_lazy_key("n", "<space>gr", function()
    require("fzf-lua").live_grep({ cmd = "git grep --line-number --column --color=always" })
  end, { desc = "Git live grep" }),
  set_lazy_key("x", "<space>gr", function()
    local selection = get_visual()
    require("fzf-lua").live_grep({
      cmd = "git grep --line-number --column --color=always",
      query = selection,
    })
  end, { desc = "Git live grep" }),
}

return M
