local uv = vim.uv or vim.loop

---@param bufnr integer?
---@return boolean
local function is_too_big(bufnr)
  if type(bufnr) == "number" then
    local constants = require("builtin.constants")
    local ok, stats = pcall(uv.fs_stat --[[@as function]], vim.api.nvim_buf_get_name(bufnr))
    return ok and stats and stats.size > constants.perf.maxfilesize
  end
  return false
end

---@param bufnr integer?
local function make_file_quick(bufnr)
  if is_too_big(bufnr) then
    vim.cmd([[
                syntax clear
                setlocal eventignore+=FileType
                setlocal undolevels=-1
            ]])
    vim.treesitter.stop(bufnr)
    vim.diagnostic.enable(false, { bufnr = bufnr })
    vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = bufnr }))
  end
end

local M = {
  is_too_big = is_too_big,
  make_file_quick = make_file_quick,
}

return M
