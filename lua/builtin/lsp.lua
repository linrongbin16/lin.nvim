-- ---- LSP ----

local constants = require("builtin.constants")
local set_key = require("builtin.utils.keymap").set_key

-- hover/signatureHelp
vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = constants.window.border })

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = constants.window.border })

local function make_opts(value)
  return { buffer = true, desc = value }
end

--- @param next boolean
--- @param severity integer?
local function goto_diagnostic(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  return function()
    go({ severity = severity })
  end
end

local lsp_goto_mapping = {
  definition = {
    mode = "n",
    lhs = "gd",
    rhs = {
      "FzfxLspDefinitions",
      { "Glance", "definitions" },
      { "lua", "vim.lsp.buf.definition()" },
    },
    desc = "Go to LSP definitions",
  },
  type_definition = {
    mode = "n",
    lhs = "gt",
    rhs = {
      "FzfxLspTypeDefinitions",
      { "Glance", "type_definitions" },
      { "lua", "vim.lsp.buf.type_definition()" },
    },
    desc = "Go to LSP type definitions",
  },
  implementation = {
    mode = "n",
    lhs = "gi",
    rhs = {
      "FzfxLspImplementations",
      { "Glance", "implementations" },
      { "lua", "vim.lsp.buf.implementation()" },
    },
    desc = "Go to LSP implementations",
  },
  reference = {
    mode = "n",
    lhs = "gr",
    rhs = {
      "FzfxLspReferences",
      { "Glance", "references" },
      { "lua", "vim.lsp.buf.reference()" },
    },
    desc = "Go to LSP references",
  },
  incoming_calls = {
    mode = "n",
    lhs = "<leader>ic",
    rhs = {
      "FzfxLspIncomingCalls",
      { "lua", "vim.lsp.buf.incoming_calls()" },
    },
    desc = "Go to LSP incoming calls",
  },
  outgoing_calls = {
    mode = "n",
    lhs = "<leader>og",
    rhs = {
      "FzfxLspOutgoingCalls",
      { "lua", "vim.lsp.buf.outgoing_calls()" },
    },
    desc = "Go to LSP outgoing calls",
  },
  hover = {
    mode = "n",
    lhs = "K",
    rhs = {
      { "lua", "vim.lsp.buf.hover()" },
    },
    desc = "Show hover",
  },
  signature_help = {
    mode = { "n", "i" },
    lhs = "<C-k>",
    rhs = {
      { "lua", "vim.lsp.buf.signature_help()" },
    },
    desc = "Show signature help",
  },
  rename = {
    mode = "n",
    lhs = "<Leader>rn",
    rhs = {
      { "lua", "vim.lsp.buf.rename()" },
    },
    desc = "Rename symbol",
  },
  code_action = {
    mode = "n",
    lhs = "<Leader>ca",
    rhs = {
      { "lua", "vim.lsp.buf.code_action()" },
    },
    desc = "Run code actions",
  },
  range_code_action = {
    mode = "x",
    lhs = "<Leader>ca",
    rhs = {
      { "lua", "vim.lsp.buf.range_code_action()" },
    },
    desc = "Run code actions",
  },
}

local function lsp_key(name, optional)
  local configs = lsp_goto_mapping[name]
  assert(type(configs) == "table")

  local hit = 0
  local right_hands = configs.rhs
  for _, right_hand in ipairs(right_hands) do
    if type(right_hand) == "string" and vim.fn.exists(":" .. right_hand) > 0 then
      set_key(
        configs.mode,
        configs.lhs,
        string.format("<CMD>%s<CR>", right_hand),
        make_opts(configs.desc)
      )
      hit = hit + 1
      break
    elseif
      type(right_hand) == "table"
      and type(right_hand[1]) == "string"
      and vim.fn.exists(":" .. right_hand[1]) > 0
    then
      set_key(
        configs.mode,
        configs.lhs,
        string.format("<CMD>%s<CR>", table.concat(right_hand, " ")),
        make_opts(configs.desc)
      )
      hit = hit + 1
      break
    end
  end
  if optional then
    assert(hit <= 1)
  else
    assert(hit == 1)
  end
end

local builtin_lsp_augroup = vim.api.nvim_create_augroup("builtin_lsp_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = builtin_lsp_augroup,
  callback = function(ev)
    vim.bo[ev.buf].formatexpr = nil
    vim.bo[ev.buf].omnifunc = nil
    vim.bo[ev.buf].tagfunc = nil

    lsp_key("definition")
    lsp_key("type_definition")
    lsp_key("implementation")
    lsp_key("reference")
    lsp_key("incoming_calls")
    lsp_key("outgoing_calls")

    lsp_key("hover")
    lsp_key("signature_help")

    lsp_key("rename")
    lsp_key("code_action")
    lsp_key("range_code_action")

    -- diagnostic
    set_key("n", "]d", goto_diagnostic(true), make_opts("Next diagnostic item"))
    set_key("n", "[d", goto_diagnostic(false), make_opts("Previous diagnostic item"))
    set_key(
      "n",
      "]e",
      goto_diagnostic(true, vim.diagnostic.severity.ERROR),
      make_opts("Go to next error")
    )
    set_key(
      "n",
      "[e",
      goto_diagnostic(false, vim.diagnostic.severity.ERROR),
      make_opts("Go to previous error")
    )
    set_key(
      "n",
      "]w",
      goto_diagnostic(true, vim.diagnostic.severity.WARN),
      make_opts("Go to next warning")
    )
    set_key(
      "n",
      "[w",
      goto_diagnostic(false, vim.diagnostic.severity.WARN),
      make_opts("Go to previous warning")
    )
  end,
})
