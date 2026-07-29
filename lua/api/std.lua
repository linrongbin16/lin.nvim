return {
  -- uv
  fs_stat = vim.uv.fs_stat,
  -- echo
  echo = vim.api.nvim_echo,
  -- buf
  buf_is_valid = vim.api.nvim_buf_is_valid,
  buf_get_name = vim.api.nvim_buf_get_name,
  -- win
  get_current_win = vim.api.nvim_get_current_win,
  -- au
  create_augroup = vim.api.nvim_create_augroup,
  create_autocmd = vim.api.nvim_create_autocmd,
}
