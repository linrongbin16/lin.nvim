local message = require("builtin.utils.message")

local linters_by_ft = {}

local user_linters_by_ft_module = "configs.mfussenegger.nvim-lint.linters_by_ft"
local user_linters_by_ft_ok, user_linters_by_ft = pcall(require, user_linters_by_ft_module)

if user_linters_by_ft_ok then
  if type(user_linters_by_ft) == "table" then
    linters_by_ft = user_linters_by_ft
  else
    message.warn(string.format("Error loading '%s' lua module!", user_linters_by_ft_module))
  end
end

require("lint").linters_by_ft = linters_by_ft

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
