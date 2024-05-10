-- ---- LSP ----

local constants = require("builtin.constants")
local set_key = require("builtin.utils.keymap").set_key

-- hover/signatureHelp
vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = constants.window.border })

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = constants.window.border })

local function make_desc(value)
  return { buffer = true, desc = value }
end

--- @param next boolean
--- @param severity integer?
local function goto_diag(next, severity)
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
  clangd_switch_source_header = {
    mode = "n",
    lhs = "<Leader>sw",
    rhs = {
      { "ClangdSwitchSourceHeader" },
    },
    desc = "Switch between C/C++ header and source files",
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
        make_desc(configs.desc)
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
        make_desc(configs.desc)
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

vim.api.nvim_create_augroup("builtin_lsp_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "builtin_lsp_augroup",
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

    lsp_key("clangd_switch_source_header", true)

    -- diagnostic
    set_key("n", "]d", goto_diag(true), make_desc("Next diagnostic item"))
    set_key("n", "[d", goto_diag(false), make_desc("Previous diagnostic item"))
    set_key(
      "n",
      "]e",
      goto_diag(true, vim.diagnostic.severity.ERROR),
      make_desc("Next diagnostic error")
    )
    set_key(
      "n",
      "[e",
      goto_diag(false, vim.diagnostic.severity.ERROR),
      make_desc("Previous diagnostic error")
    )
    set_key(
      "n",
      "]w",
      goto_diag(true, vim.diagnostic.severity.WARN),
      make_desc("Next diagnostic warning")
    )
    set_key(
      "n",
      "[w",
      goto_diag(false, vim.diagnostic.severity.WARN),
      make_desc("Previous diagnostic warning")
    )
  end,
})

local function setup_diagnostic()
  local highlights = {
    DiagnosticError = { "ErrorMsg", "#ff0000" },
    DiagnosticWarn = { "WarningMsg", "#FFFF00" },
    DiagnosticInfo = { "Normal", "#00FFFF" },
    DiagnosticHint = { "Comment", "#808080" },
    DiagnosticOk = { "Normal", "#008000" },
  }
  for name, hl in pairs(highlights) do
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
      source = "always",
      header = "",
      prefix = "",
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

  local signs = {
    DiagnosticSignError = constants.diagnostic.signs.error,
    DiagnosticSignWarn = constants.diagnostic.signs.warning,
    DiagnosticSignInfo = constants.diagnostic.signs.info,
    DiagnosticSignHint = constants.diagnostic.signs.hint,
    DiagnosticSignOk = constants.diagnostic.signs.ok,
  }
  for name, text in pairs(signs) do
    vim.fn.sign_define(name, {
      texthl = name,
      text = text,
      numhl = "",
    })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = "builtin_lsp_augroup",
  callback = vim.schedule_wrap(setup_diagnostic),
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = "builtin_lsp_augroup",
  callback = vim.schedule_wrap(setup_diagnostic),
})
