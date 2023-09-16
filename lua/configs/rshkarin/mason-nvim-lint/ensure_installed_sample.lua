-- Please copy this file to 'ensure_installed.lua' to enable it.

-- Ensure installed nvim-lint linters via mason.
-- This module will be passed to `require("mason-nvim-lint").setup({ ensure_installed = ... })`.

local ensure_installed = {
    "luacheck", -- lua formatter
    "eslint", -- js,ts,json,html,css,etc diagnostic
}

return ensure_installed
