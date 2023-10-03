-- Please copy this file to 'ensure_installed.lua' to enable it.

-- Ensure installed null-ls sources.
-- This module will be passed to `require("mason-null-ls").setup({ ensure_installed = ... })`.
-- For full null-ls sources list, please refer to:
--  * [null-ls BUILTINS](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md) and install them from mason.

local ensure_installed = {
    "stylua", -- lua formatter
    "prettier", -- js,ts,json,html,css,etc formatter
    "eslint", -- js,ts,json,html,css,etc diagnostic
}

return ensure_installed