-- neodev, neoconf
require("neodev").setup()
require("neoconf").setup()

-- user setup handlers
local lspconfig = require("lspconfig")

local setup_handlers_ok, setup_handlers =
    pcall(require, "configs.neovim.nvim-lspconfig.setup_handlers")

if not setup_handlers_ok then
    setup_handlers = {}
end

for name, config in pairs(setup_handlers) do
    lspconfig[name].setup(config)
end