local constants = require("builtin.constants")

require("ibl").setup({
  scope = { enabled = false },
})

local hooks = require("ibl.hooks")
hooks.register(hooks.type.ACTIVE, function(bufnr)
  local f = vim.api.nvim_buf_get_name(bufnr)
  return vim.fn.getfsize(f) <= constants.perf.maxfilesize
end)
