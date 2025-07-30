-- ---- Constants ----

local M = {}

M.diagnostics = {
  error = "", -- nf-fa-times \uf00d
  warning = "", -- nf-fa-warning \uf071
  info = "", -- nf-fa-info_circle \uf05a
  hint = "", -- nf-fa-bell \uf0f3
  ok = "", -- nf-fa-check \uf00c
}

M.window = {
  -- window border options: single,double,rounded,solid,shadow,bold,none
  border = "rounded",

  -- single border chars
  -- border_chars = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }, -- double
  -- border_chars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }, -- single
  border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- rounded
  -- border_chars = { " ", " ", " ", " ", " ", " ", " ", " " }, -- none
  -- border_chars = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" }, -- bold

  blend = 15,
}

M.layout = {
  window = { scale = 0.85 },
  sidebar = { scale = 0.2, min = 20, max = 60 },
  input = { scale = 0.3, min = 30, max = 60 },
  select = { scale = 0.5, min = 40, max = 100 },
}

M.perf = {
  maxfilesize = 1024 * 1024 * 2, -- 2 MB
}

M = vim.tbl_deep_extend("force", M, vim.g.lin_nvim_builtin_constants or {}) --[[@as table]]

local os_name = vim.loop.os_uname().sysname

M.os = {
  name = os_name,
  is_macos = vim.fn.has("mac") > 0,
  is_windows = vim.fn.has("win32") > 0 or vim.fn.has("win64") > 0,
  is_bsd = vim.fn.has("bsd") > 0,
}

return M
