local bigfile = require("builtin.utils.bigfile")

require("illuminate").configure({
  providers = { "regex" },
  -- disable for big file
  should_enable = function(bufnr)
    return not bigfile.is_too_big(bufnr)
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
