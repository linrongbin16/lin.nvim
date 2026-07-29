return {
  win_get_cursor = vim.api.nvim_win_get_cursor,
  -- au
  create_augroup = vim.api.nvim_create_augroup,
  create_autocmd = vim.api.nvim_create_autocmd,
  -- misc
  echo = vim.api.nvim_echo,
  get_mode = vim.api.nvim_get_mode,
}
