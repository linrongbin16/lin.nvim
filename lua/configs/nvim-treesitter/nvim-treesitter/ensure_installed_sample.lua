-- Please copy this file to 'ensure_installed.lua' to enable it.

-- Ensure installed nvim-treesitter parsers.
-- This module will be passed to `require("nvim-treesitter.configs").setup({ ensure_installed = ... })`.

local ensure_installed = {
  "vim", -- vim
  "lua", -- lua
  "markdown", -- markdown
  "javascript", -- javascript
  "typescript", -- typescript
  "tsx", -- jsx/tsx
}

return ensure_installed
