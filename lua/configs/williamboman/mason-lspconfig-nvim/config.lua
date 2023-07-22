local lspconfig = require("lspconfig")
local message = require("builtin.utils.message")

local ensure_installed = {}

local user_ensure_installed_module =
    "configs.williamboman.mason-lspconfig-nvim.ensure_installed"
local user_ensure_installed_ok, user_ensure_installed =
    pcall(require, user_ensure_installed_module)

if user_ensure_installed_ok then
    if type(user_ensure_installed) == "table" then
        ensure_installed = user_ensure_installed
    else
        message.warn(
            string.format(
                "Error loading '%s' lua module!",
                user_ensure_installed_module
            )
        )
    end
end

require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

local setup_handlers = {
    -- use default setup for all lsp servers
    function(server)
        lspconfig[server].setup({})
    end,
}

local user_setup_handlers_module =
    "configs.williamboman.mason-lspconfig-nvim.setup_handlers"
local user_setup_handlers_ok, user_setup_handlers =
    pcall(require, user_setup_handlers_module)

if user_setup_handlers_ok then
    if type(user_setup_handlers) == "table" then
        for name, handler in pairs(user_setup_handlers) do
            setup_handlers[name] = handler
        end
    else
        message.warn(
            string.format(
                "Error loading '%s' lua module!",
                user_setup_handlers_module
            )
        )
    end
end

require("mason-lspconfig").setup_handlers(setup_handlers)