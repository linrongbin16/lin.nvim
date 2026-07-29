local uv = vim.uv or vim.loop

local fs_stat = vim.uv.fs_stat

local M = {
  uv = uv,
  fs_stat = fs_stat,
}

return M
