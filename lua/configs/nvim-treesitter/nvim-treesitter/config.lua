local str = require("commons.str")

local stdpath_config = vim.fn.stdpath("config")

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter").setup({
  install_dir = stdpath_config .. "/treesitter",
})

-- Highlight per filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function(event)
    if event ~= nil and type(event.buf) == "number" and vim.api.nvim_buf_is_valid(event.buf) then
      local ft = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
      if str.not_empty(ft) then
        vim.print(string.format("Install nvim-treesitter parser for %s", vim.inspect(ft)))
        require("nvim-treesitter").install({ ft })
      else
        vim.print(
          string.format(
            "Cannot install nvim-treesitter parser for buffer %s",
            vim.inspect(event.buf)
          )
        )
      end
    end
    vim.treesitter.start()
  end,
})

-- Indentation
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Fold
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
