local std = require("api.std")
local stdpath_config = vim.fn.stdpath("config")

require("ts-install").setup({
  auto_install = true,
  install_dir = stdpath_config .. "/ts-install",
})

local ts_install = std.create_augroup("ts_install", { clear = true })
std.create_autocmd("FileType", {
  group = ts_install,
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
