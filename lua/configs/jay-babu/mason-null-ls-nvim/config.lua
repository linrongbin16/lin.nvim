local message = require("builtin.utils.message")

local ensure_installed = {}

local user_ensure_installed_module =
    "configs.jay-babu.mason-null-ls-nvim.ensure_installed"
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

local setup_handlers = {}

local user_setup_handlers_module =
    "configs.jay-babu.mason-null-ls-nvim.setup_handlers"
local user_setup_handlers_ok, user_setup_handlers =
    pcall(require, user_setup_handlers_module)

if user_setup_handlers_ok then
    if type(user_setup_handlers) == "table" then
        setup_handlers = user_setup_handlers
    else
        message.warn(
            string.format(
                "Error loading '%s' lua module!",
                user_setup_handlers_module
            )
        )
    end
end

require("mason-null-ls").setup({
    ensure_installed = ensure_installed,
    handlers = setup_handlers,
})