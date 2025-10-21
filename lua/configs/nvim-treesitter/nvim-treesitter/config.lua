local stdpath_config = vim.fn.stdpath("config")

require("nvim-treesitter").setup({
  install_dir = stdpath_config .. "/treesitter",
})
