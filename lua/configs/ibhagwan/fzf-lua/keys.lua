local constants = require("builtin.constants")
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

local function clamp(v, min_val, max_val)
  local res = v
  if max_val ~= nil then
    res = math.min(res, max_val)
  end
  if min_val ~= nil then
    res = math.max(res, min_val)
  end
  return res
end

local function get_cursor_winopts()
  local winnr = vim.api.nvim_get_current_win()
  local win_first_lineno = vim.fn.line("w0")
  local win_height = vim.api.nvim_win_get_height(winnr)
  local win_width = vim.api.nvim_win_get_width(winnr)
  local win_pos = vim.api.nvim_win_get_position(winnr)
  -- local win_y = win_pos[1]
  local win_x = win_pos[2]
  local border = constants.window.border

  local height = clamp(win_height, 3, 18)
  local width = win_width

  local cursor_pos = vim.api.nvim_win_get_cursor(winnr)
  local cursor_lineno = cursor_pos[1]
  local lines_till_cursor = vim.fn.getline(win_first_lineno, cursor_lineno) --[[@as string[] ]]

  local cursor_row = 1
  for _, l in ipairs(lines_till_cursor) do
    local lw = vim.fn.strdisplaywidth(l)
    cursor_row = cursor_row + 1 + math.floor(lw / win_width)
  end
  cursor_row = clamp(cursor_row, 2)

  -- local cursor_row = clamp(cursor_lineno - win_first_lineno + 2, 2)
  -- local cursor_col = cursor_pos[2]
  local cursor_col = win_x

  local expected_end_row = cursor_row + height
  local expected_reversed_cursor_row = cursor_row - 1 - height
  if expected_end_row > win_height and expected_reversed_cursor_row >= 1 then
    cursor_row = expected_reversed_cursor_row
  end

  local result = {
    height = height,
    width = width,
    row = cursor_row,
    col = cursor_col,
    border = "none",
    win = winnr,
    style = "minimal",
    preview = {
      default = "bat",
      border = border,
      horizontal = "left:66%",
    },
  }
  -- print(string.format("3-res:%s", vim.inspect(result)))
  return result
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

  -- lsp locations
  set_lazy_key("n", "gd", function()
    require("fzf-lua").lsp_definitions({
      winopts = get_cursor_winopts(),
      prompt = "Definitions> ",
    })
  end, { desc = "Go to definitions" }),
  set_lazy_key("n", "gr", function()
    require("fzf-lua").lsp_references({
      winopts = get_cursor_winopts(),
      prompt = "References> ",
    })
  end, { desc = "Go to references" }),
  set_lazy_key("n", "gt", function()
    require("fzf-lua").lsp_typedefs({
      winopts = get_cursor_winopts(),
      prompt = "Type Definitions> ",
    })
  end, { desc = "Go to type definitions" }),
  set_lazy_key("n", "gi", function()
    require("fzf-lua").lsp_implementations({
      winopts = get_cursor_winopts(),
      prompt = "Implementations> ",
    })
  end, { desc = "Go to implementations" }),
}

return M
