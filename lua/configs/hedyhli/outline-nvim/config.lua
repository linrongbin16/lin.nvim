local constants = require("builtin.constants")

require("outline").setup({
  outline_window = {
    width = constants.layout.sidebar.scale * 100,
    focus_on_open = false,
  },
  outline_items = {
    auto_update_events = {
      items = {
        "InsertLeave",
        "WinEnter",
        "BufEnter",
        "BufNewFile",
        "BufReadPost",
        "BufWritePost",
        "TermLeave",
        "TermClose",
        "FocusGained",
        "FocusLost",
        "LspAttach",
        "LspDetach",
        "LspTokenUpdate",
      },
    },
  },
  symbol_folding = {
    autofold_depth = 5,
    auto_unfold = {
      hovered = false,
    },
  },
  symbols = {
    filter = {
      "Property",
      "Field",
      "String",
      "Number",
      "Boolean",
      "Null",
      "Variable",
      "Constant",
      "Package",
      "Array",
      exclude = true,
    },
  },
})

local outline_augroup = vim.api.nvim_create_augroup("outline_augroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = outline_augroup,
  pattern = "Outline",
  callback = function()
    local keymap = require("util.keymap")
    local opts = { buffer = true }
    keymap.set("n", "<leader>.", "<cmd>vertical resize -10<cr>", opts)
    keymap.set("n", "<leader>,", "<cmd>vertical resize +10<cr>", opts)
  end,
})
