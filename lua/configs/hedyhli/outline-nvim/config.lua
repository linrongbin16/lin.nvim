local constants = require("builtin.constants")

require("outline").setup({
  outline_window = {
    width = constants.layout.sidebar.scale * 100,
    focus_on_open = false,
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
    local set_key = require("builtin.utils.keymap").set_key
    local opts = { buffer = true }
    set_key("n", "<leader>.", "<cmd>vertical resize -10<cr>", opts)
    set_key("n", "<leader>,", "<cmd>vertical resize +10<cr>", opts)
  end,
})
