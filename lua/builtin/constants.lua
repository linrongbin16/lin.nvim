-- ---- Constants ----

local M = {}

M.diagnostic = {
  signs = {
    error = "", -- nf-fa-times \uf00d
    warning = "", -- nf-fa-warning \uf071
    info = "", -- nf-fa-info_circle \uf05a
    hint = "", -- nf-fa-bell \uf0f3
    ok = "", -- nf-fa-check \uf00c
  },
}

M.ui = {
  border = "rounded", -- single,double,rounded,solid,shadow
  winblend = 15,
  pumblend = 15,
  layout = {
    middle = {
      scale = 0.85,
    },
    large = {
      scale = 0.9,
    },
    sidebar = {
      scale = 0.2,
      min = 20,
      max = 60,
    },
  },
}

M.perf = {
  maxfilesize = 1024 * 1024 * 5, -- 5 MB
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
