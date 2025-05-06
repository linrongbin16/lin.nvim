-- ---- LSP ----

local set_key = require("builtin.utils.keymap").set_key

local NVIM_VERSION_0_11_0 = vim.fn.has("nvim-0.11.0") > 0

--- @param next boolean
--- @param severity integer?
local function goto_diagnostic(next, severity)
  if NVIM_VERSION_0_11_0 then
    local count = next and 1 or -1
    return function()
      vim.diagnostic.jump({ severity = severity, count = count, float = true })
    end
  else
    ---@diagnostic disable-next-line: deprecated
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    return function()
      go({ severity = severity })
    end
  end
end

set_key("n", "gd", function()
  if vim.fn.exists(":FzfxLspDefinitions") > 0 then
    vim.cmd("FzfxLspDefinitions")
  else
    vim.lsp.buf.definition()
  end
end, { desc = "Go to LSP definitions" })

set_key("n", "gt", function()
  if vim.fn.exists(":FzfxLspTypeDefinitions") > 0 then
    vim.cmd("FzfxLspTypeDefinitions")
  else
    vim.lsp.buf.type_definition()
  end
end, { desc = "Go to LSP type definitions" })

set_key("n", "gi", function()
  if vim.fn.exists(":FzfxLspImplementations") > 0 then
    vim.cmd("FzfxLspImplementations")
  else
    vim.lsp.buf.implementation()
  end
end, { desc = "Go to LSP implementations" })

set_key("n", "gr", function()
  if vim.fn.exists(":FzfxLspReferences") > 0 then
    vim.cmd("FzfxLspReferences")
  else
    vim.lsp.buf.references()
  end
end, { desc = "Go to LSP references" })

set_key("n", "K", function()
  vim.lsp.buf.hover()
end, { desc = "Show LSP hover" })

set_key({ "n", "i" }, "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { desc = "Show LSP signature help" })

set_key("n", "<Leader>rn", function()
  vim.lsp.buf.rename()
end, { desc = "Rename LSP symbol" })

set_key("n", "<Leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Run LSP code action" })

set_key("x", "<Leader>ca", function()
  vim.lsp.buf.range_code_action()
end, { desc = "Run LSP code action on visual selection" })

set_key("n", "]d", goto_diagnostic(true), { desc = "Next diagnostic item" })
set_key("n", "[d", goto_diagnostic(false), { desc = "Previous diagnostic item" })
set_key(
  "n",
  "]e",
  goto_diagnostic(true, vim.diagnostic.severity.ERROR),
  { desc = "Go to next error" }
)
set_key(
  "n",
  "[e",
  goto_diagnostic(false, vim.diagnostic.severity.ERROR),
  { desc = "Go to previous error" }
)
set_key(
  "n",
  "]w",
  goto_diagnostic(true, vim.diagnostic.severity.WARN),
  { desc = "Go to next warning" }
)
set_key(
  "n",
  "[w",
  goto_diagnostic(false, vim.diagnostic.severity.WARN),
  { desc = "Go to previous warning" }
)

local builtin_lsp_augroup = vim.api.nvim_create_augroup("builtin_lsp_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = builtin_lsp_augroup,
  callback = function(ev)
    vim.bo[ev.buf].formatexpr = nil
    vim.bo[ev.buf].omnifunc = nil
    vim.bo[ev.buf].tagfunc = nil
  end,
})
