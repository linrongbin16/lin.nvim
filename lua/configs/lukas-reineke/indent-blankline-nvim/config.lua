local bigfile = require("builtin.utils.bigfile")

require("ibl").setup({
  scope = { enabled = false },
})

local hooks = require("ibl.hooks")
hooks.register(hooks.type.ACTIVE, function(bufnr)
  return not bigfile.is_too_big(bufnr)
end)
