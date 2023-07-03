local lspconfig = require("lspconfig")

-- Check if `setup_handlers` exist
local found_setup_handlers, setup_handlers =
    pcall(require, "repo.neovim.nvim-lspconfig.setup_handlers")

if not found_setup_handlers then
    setup_handlers = {}
end

for name, config in pairs(setup_handlers) do
    lspconfig[name].setup(config)
end