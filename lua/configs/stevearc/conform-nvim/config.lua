local message = require("builtin.utils.message")

local formatters_by_ft = nil

local user_formatters_by_ft_module = "configs.stevearc.conform-nvim.formatters_by_ft"
local user_formatters_by_ft_ok, user_formatters_by_ft = pcall(require, user_formatters_by_ft_module)

if user_formatters_by_ft_ok then
    if type(user_formatters_by_ft) == "table" then
        formatters_by_ft = user_formatters_by_ft
    else
        message.warn(string.format("Error loading '%s' lua module!", user_formatters_by_ft_module))
    end
end

require("conform").setup({
    formatters_by_ft = formatters_by_ft,

    format_after_save = {
        lsp_fallback = true,
    },
})
