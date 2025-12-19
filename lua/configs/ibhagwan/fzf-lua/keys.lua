local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local function get_visual_select()
  return table.concat(
    vim.fn.getregion(
      vim.fn.getpos("."),
      vim.fn.getpos("v"),
      { type = vim.api.nvim_get_mode().mode }
    )
  )
end

local function get_cwd()
  return vim.fn.pathshorten(vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.")) .. "> "
end

local function get_cword()
  return vim.fn.expand("<cword>")
end

local M = {
  -- find files
  set_lazy_key("n", "<space>f", function()
    require("fzf-lua").files({ prompt = get_cwd() })
  end, { desc = "Find files" }),
  set_lazy_key("x", "<space>f", function()
    require("fzf-lua").files({ query = get_visual_select(), prompt = get_cwd() })
  end, { desc = "Find files" }),
  set_lazy_key("n", "<space>wf", function()
    require("fzf-lua").files({ query = get_cword(), prompt = get_cwd() })
  end, { desc = "Find files by cword" }),
  set_lazy_key("n", "<space>wf", function()
    require("fzf-lua").files({ query = get_cword(), prompt = get_cwd() })
  end, { desc = "Find files by cword" }),
  set_lazy_key("n", "<space>rf", function()
    require("fzf-lua").files({ resume = true, prompt = get_cwd() })
  end, { desc = "Find files by resume" }),

  -- find git files
  set_lazy_key("n", "<space>gf", function()
    require("fzf-lua").git_files({ prompt = get_cwd() })
  end, { desc = "Search git files" }),
  set_lazy_key("x", "<space>gf", function()
    require("fzf-lua").git_files({ query = get_visual_select(), prompt = get_cwd() })
  end, { desc = "Search git files" }),

  -- search buffers
  set_lazy_key("n", "<space>bf", function()
    require("fzf-lua").buffers()
  end, { desc = "Search buffers" }),
  set_lazy_key("x", "<space>bf", function()
    require("fzf-lua").buffers({ query = get_visual_select() })
  end, { desc = "Search buffers" }),

  -- live grep
  set_lazy_key("n", "<space>l", function()
    require("fzf-lua").live_grep()
  end, { desc = "Live grep" }),
  set_lazy_key("x", "<space>l", function()
    require("fzf-lua").live_grep({ query = get_visual_select() })
  end, { desc = "Live grep" }),
  set_lazy_key("n", "<space>wl", function()
    require("fzf-lua").live_grep({ query = get_cword() })
  end, { desc = "Live grep by cword" }),
  set_lazy_key("n", "<space>rl", function()
    require("fzf-lua").live_grep({ resume = true })
  end, { desc = "Live grep by resume " }),

  -- git live grep
  set_lazy_key("n", "<space>gl", function()
    require("fzf-lua").live_grep({
      cmd = "git grep --line-number --column --color=always",
      prompt = "Live Grep (Git)> ",
    })
  end, { desc = "Git live grep" }),
  set_lazy_key("x", "<space>gl", function()
    require("fzf-lua").live_grep({
      cmd = "git grep --line-number --column --color=always",
      query = get_visual_select(),
      prompt = "Live Grep (Git)> ",
    })
  end, { desc = "Git live grep" }),
  set_lazy_key("x", "<space>wgl", function()
    require("fzf-lua").live_grep({
      cmd = "git grep --line-number --column --color=always",
      query = get_cword(),
      prompt = "Live Grep (Git)> ",
    })
  end, { desc = "Git live grep by cword" }),
  set_lazy_key("x", "<space>rgl", function()
    require("fzf-lua").live_grep({
      resume = true,
      cmd = "git grep --line-number --column --color=always",
      query = get_cword(),
      prompt = "Live Grep (Git)> ",
    })
  end, { desc = "Git live grep by resume" }),
}

return M
