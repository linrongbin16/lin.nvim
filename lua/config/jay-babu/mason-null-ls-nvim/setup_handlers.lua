-- Configure null-ls source builtins.
-- This module will be passed to `require("mason-null-ls").setup_handlers(setup_handlers)`.
--
-- For full null-ls source builtins, please refer to:
--      * [null-ls BUILTINS](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md).

local null_ls = require("null-ls")

local setup_handlers = {
    -- specific setup
    stylua = function(source, methods)
        null_ls.register(null_ls.builtins.formatting.stylua)
    end,
    markdownlint = function(source, methods)
        null_ls.register(null_ls.builtins.diagnostics.markdownlint)
    end,
}

return setup_handlers