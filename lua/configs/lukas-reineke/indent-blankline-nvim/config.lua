require("ibl").setup({
  scope = { enabled = false },
})

local hooks = require("ibl.hooks")
hooks.register(hooks.type.ACTIVE, function(bufnr)
  local performance = require("builtin.performance")
  return not performance.file_too_big(bufnr)
end)
