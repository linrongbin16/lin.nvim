local message = require("builtin.utils.message")

local ensure_installed = {}

local user_ensure_installed_module =
    "configs.rshkarin.mason-nvim-lint.ensure_installed"
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

require("mason-nvim-lint").setup({
    ensure_installed = ensure_installed,
    automatic_installation = false,
})
