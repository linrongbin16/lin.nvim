-- ---- Key Map ----

--- @param rhs string|function|nil
--- @param opts table<any, any>
--- @return table<any, any>
local function make_opts(rhs, opts)
  local default_opts = {
    silent = true,
    noremap = true,
    -- buffer = false,
  }
  opts = vim.tbl_deep_extend("force", vim.deepcopy(default_opts), opts or {})
  -- forcibly set `noremap=false` for <Plug>
  if
    type(rhs) == "string"
    and string.len(rhs) >= 6
    and string.sub(rhs, 1, 6):lower() == "<plug>"
  then
    opts.noremap = false
  end
  return opts
end

--- @param mode string|string[]
--- @param lhs string
--- @param rhs string|function
--- @param opts table<any, any>
--- @return nil
local function set(mode, lhs, rhs, opts)
  opts = make_opts(rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

--- @param mode string|string[]
--- @param lhs string
--- @param rhs string|function|nil
--- @param opts table<any, any>
local function set_lazily(mode, lhs, rhs, opts)
  opts = make_opts(rhs, opts)
  local key_spec = { lhs, rhs, mode = mode }
  for k, v in pairs(opts) do
    key_spec[k] = v
  end
  return key_spec
end

local M = {
  set = set,
  set_lazily = set_lazily,
}

return M
