vim.g.cursorword_highlight = 0
vim.g.cursorword_delay = 100

local cursorword_augroup = vim.api.nvim_create_augroup("cursorword_augroup", { clear = true })

vim.api.nvim_create_autocmd({ "UIEnter", "Colorscheme" }, {
  group = cursorword_augroup,
  callback = function()
    vim.schedule(function()
      local cl = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false }) --[[@as table]]
      cl.bold = true
      cl.underline = true
      if type(cl.cterm) ~= "table" then
        cl.cterm = {}
      end
      cl.cterm.bold = true
      cl.cterm.underline = true
      cl.force = true
      vim.api.nvim_set_hl(0, "CursorWord", cl)
    end)
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = cursorword_augroup,
  callback = function()
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      local bigfile = require("builtin.utils.bigfile")
      if bigfile.is_too_big(bufnr) then
        vim.b.cursorword = 0
      end
    end)
  end,
})
