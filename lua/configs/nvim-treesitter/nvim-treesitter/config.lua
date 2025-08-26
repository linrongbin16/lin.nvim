local stdpath_config = vim.fn.stdpath("config")

require("nvim-treesitter").setup({
  install_dir = stdpath_config .. "/treesitter",
})

-- local nvim_treesitter_augroup =
--   vim.api.nvim_create_augroup("nvim_treesitter_augroup", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   group = nvim_treesitter_augroup,
--   pattern = { "<filetype>" },
--   callback = function()
--     vim.treesitter.start()
--   end,
-- })
--
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
