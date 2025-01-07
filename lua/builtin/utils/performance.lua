local uv = vim.uv or vim.loop

---@param bufnr integer
local function file_too_big(bufnr)
  local constants = require("builtin.constants")
  local ok, stats = pcall(uv.fs_stat --[[@as function]], vim.api.nvim_buf_get_name(bufnr))
  return ok and stats and stats.size > constants.perf.maxfilesize
end

local M = {
  file_too_big = file_too_big,
}

return M
