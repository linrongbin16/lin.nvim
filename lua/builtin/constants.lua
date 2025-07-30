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
  border = "rounded", -- single,double,rounded,solid,shadow
  layout = {
    middle = { scale = 0.85 },
    large = { scale = 0.9 },
    sidebar = { scale = 0.2, min = 20, max = 60 },
    input = { scale = 0.3, min = 30, max = 60 },
    select = { scale = 0.5, min = 40, max = 100 },
    cmdline = { scale = 0.5, min = 40, max = 100 },
  },
  blend = 15,
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
