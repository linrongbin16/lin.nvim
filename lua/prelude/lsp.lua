-- ---- LSP ----

local keymap = require("util.keymap")

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

keymap.set("n", "K", function()
  vim.lsp.buf.hover()
end, { desc = "Show LSP hover" })

keymap.set({ "n", "i" }, "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { desc = "Show LSP signature help" })

keymap.set("n", "<Leader>rn", function()
  vim.lsp.buf.rename()
end, { desc = "Rename LSP symbol" })

-- keymap.set("n", "<Leader>ca", function()
--   vim.lsp.buf.code_action()
-- end, { desc = "Run LSP code action" })
--
-- keymap.set("x", "<Leader>ca", function()
--   vim.lsp.buf.range_code_action()
-- end, { desc = "Run LSP code action on visual selection" })

keymap.set("n", "]d", goto_diagnostic(true), { desc = "Next diagnostic item" })
keymap.set("n", "[d", goto_diagnostic(false), { desc = "Previous diagnostic item" })
keymap.set(
  "n",
  "]e",
  goto_diagnostic(true, vim.diagnostic.severity.ERROR),
  { desc = "Go to next error" }
)
keymap.set(
  "n",
  "[e",
  goto_diagnostic(false, vim.diagnostic.severity.ERROR),
  { desc = "Go to previous error" }
)
keymap.set(
  "n",
  "]w",
  goto_diagnostic(true, vim.diagnostic.severity.WARN),
  { desc = "Go to next warning" }
)
keymap.set(
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
