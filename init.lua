-- ======== Init ========

-- pre init
local preinit_vim = string.format("%s/preinit.vim", vim.fn.stdpath("config"))
if vim.fn.filereadable(preinit_vim) > 0 then
    vim.fn.execute(string.format("source %s", preinit_vim), true)
end
pcall(require, "preinit")

-- options
require("builtin.options")
require("builtin.lsp")

-- plugins
require("configs.folke.lazy-nvim.config")

-- others
require("builtin.colors")
require("builtin.others")

-- post init
local postinit_vim = string.format("%s/postinit.vim", vim.fn.stdpath("config"))
if vim.fn.filereadable(postinit_vim) > 0 then
    vim.fn.execute(string.format("source %s", postinit_vim), true)
end
pcall(require, "postinit")
