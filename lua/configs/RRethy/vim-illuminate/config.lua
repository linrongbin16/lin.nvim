local constants = require("builtin.constants")

require("illuminate").configure({
  -- disable cursor word for big file
  large_file_cutoff = constants.perf.maxfilesize,
})

-- highlight style
vim.api.nvim_create_augroup("vim_illuminate_augroup", { clear = true })
vim.api.nvim_create_autocmd({ "UIEnter", "BufReadPre", "BufNewFile" }, {
  group = "vim_illuminate_augroup",
  callback = function()
    vim.cmd([[hi illuminatedWord cterm=underline gui=underline]])
  end,
})
