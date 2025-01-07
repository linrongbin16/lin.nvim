local constants = require("builtin.constants")

require("illuminate").configure({
  delay = 300,
  -- disable for big file
  should_enable = function(bufnr)
    local f = vim.api.nvim_buf_get_name(bufnr)
    return vim.fn.getfsize(f) <= constants.perf.maxfilesize
  end,
})

-- highlight style
local vim_illuminate_augroup =
  vim.api.nvim_create_augroup("vim_illuminate_augroup", { clear = true })
vim.api.nvim_create_autocmd({ "UIEnter", "BufReadPre", "BufNewFile" }, {
  group = vim_illuminate_augroup,
  callback = function()
    vim.cmd([[hi illuminatedWord cterm=underline gui=underline]])
  end,
})
