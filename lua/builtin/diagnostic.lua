-- ---- Diagnostic ----

local constants = require("builtin.constants")

local function setup_diagnostic()
  local highlights_def = {
    DiagnosticError = { "ErrorMsg", "#ff0000" },
    DiagnosticWarn = { "WarningMsg", "#FFFF00" },
    DiagnosticInfo = { "Normal", "#00FFFF" },
    DiagnosticHint = { "Comment", "#808080" },
    DiagnosticOk = { "Normal", "#008000" },
  }
  for name, hl in pairs(highlights_def) do
    local old_hl = vim.api.nvim_get_hl(0, { name = name })
    if type(old_hl) ~= "table" or vim.tbl_isempty(old_hl) then
      local new_hl = vim.api.nvim_get_hl(0, { name = hl[1] })
      if type(new_hl) == "table" and not vim.tbl_isempty(new_hl) then
        vim.api.nvim_set_hl(0, name, { link = hl[1] })
      else
        vim.api.nvim_set_hl(0, name, { fg = hl[2] })
      end
    end
  end

  vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    float = {
      border = constants.window.border,
      source = true,
      header = "",
      prefix = "",
      suffix = "",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = constants.diagnostic.signs.error,
        [vim.diagnostic.severity.WARN] = constants.diagnostic.signs.warning,
        [vim.diagnostic.severity.INFO] = constants.diagnostic.signs.info,
        [vim.diagnostic.severity.HINT] = constants.diagnostic.signs.hint,
      },
    },
  })

  -- local signs_def = {
  --   DiagnosticSignError = constants.diagnostic.signs.error,
  --   DiagnosticSignWarn = constants.diagnostic.signs.warning,
  --   DiagnosticSignInfo = constants.diagnostic.signs.info,
  --   DiagnosticSignHint = constants.diagnostic.signs.hint,
  --   DiagnosticSignOk = constants.diagnostic.signs.ok,
  -- }
  -- for name, text in pairs(signs_def) do
  --   vim.fn.sign_define(name, {
  --     texthl = name,
  --     text = text,
  --     numhl = "",
  --   })
  -- end
end

local builtin_diagnostic_augroup =
  vim.api.nvim_create_augroup("builtin_diagnostic_augroup", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = builtin_diagnostic_augroup,
  callback = vim.schedule_wrap(setup_diagnostic),
})
vim.api.nvim_create_autocmd("VimEnter", {
  group = builtin_diagnostic_augroup,
  callback = vim.schedule_wrap(setup_diagnostic),
})
