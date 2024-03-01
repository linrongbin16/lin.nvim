local constants = require("builtin.utils.constants")

---@return string?
local function hlcode(name)
  local hlnr = vim.fn.hlID(name)
  if type(hlnr) ~= "number" or hlnr <= 0 then
    return nil
  end
  local synnr = vim.fn.synIDtrans(hlnr)
  if type(synnr) ~= "number" or synnr <= 0 then
    return nil
  end
  local guicode = vim.fn.synIDattr(synnr, "fg", "gui")
  if type(guicode) == "string" and string.len(guicode) > 0 then
    return guicode
  end
  return vim.fn.synIDattr(synnr, "fg", "cterm")
end

local HL = "#806d9c"
local ERRHL = "#c21f30"

do
  local line_nr = hlcode("Float")
  if line_nr then
    HL = line_nr
  end
  local err_msg = hlcode("DiagnosticError")
  if err_msg then
    ERRHL = err_msg
  else
    err_msg = hlcode("ErrorMsg")
    if err_msg then
      ERRHL = err_msg
    end
  end
end

require("hlchunk").setup({
  chunk = {
    notify = false,
    style = {
      { fg = HL },
      { fg = ERRHL },
    },
    max_file_size = constants.perf.file.maxsize,
  },
  line_num = {
    enable = true,
    use_treesitter = false,
    style = HL,
  },
  blank = {
    enable = false,
  },
})
