local message = require("builtin.utils.message")

local setup_handlers = {}

local user_setup_handlers_module = "configs.jay-babu.mason-null-ls-nvim.setup_handlers"
local user_setup_handlers_ok, user_setup_handlers = pcall(require, user_setup_handlers_module)

if user_setup_handlers_ok then
  if type(user_setup_handlers) == "table" then
    setup_handlers = user_setup_handlers
  else
    message.err(string.format("Error loading '%s' lua module!", user_setup_handlers_module))
  end
end

require("mason-null-ls").setup({
  handlers = setup_handlers,
})
