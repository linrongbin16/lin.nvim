-- ---- Constants ----

local M = {}

M.lsp = {
  diagnostics = {
    signs = {
      ["error"] = "", -- nf-fa-times \uf00d
      ["warning"] = "", -- nf-fa-warning \uf071
      ["info"] = "", -- nf-fa-info_circle \uf05a
      -- ["hint"] = "", -- nf-mdi-lightbulb \uf834, used for codeAction in vscode, choose another icon
      ["hint"] = "", -- : nf-fa-flag \uf024,  nf-fa-bell \uf0f3
      ["ok"] = "", -- nf-fa-check \uf00c
    },
  },
}

M.ui = {
  border = "rounded", -- border options: single,double,rounded,solid,shadow
}

M.perf = {
  -- performance
  filesystem = {
    maxsize = 1024 * 1024 * 5, -- 5MB
  },
}

M.fs = {
  path_separator = package.config:sub(1, 1), -- Windows: '\\', *NIX: '/'
}

return M
