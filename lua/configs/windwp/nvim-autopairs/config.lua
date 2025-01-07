local constants = require("builtin.constants")

require("nvim-autopairs").setup()

local autopairs_augroup = vim.api.nvim_create_augroup("autopairs_augroup", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  group = autopairs_augroup,
  callback = function(event)
    require("nvim-autopairs").disable()
    if type(event) == "table" and type(event.buf) == "number" then
      local f = vim.api.nvim_buf_get_name(event.buf)
      if vim.fn.getfsize(f) <= constants.perf.maxfilesize then
        require("nvim-autopairs").enable()
      end
    end
  end,
})
