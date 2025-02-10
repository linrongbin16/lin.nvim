local bigfile = require("builtin.utils.bigfile")

require("illuminate").configure({
  providers = { "regex" },
  -- disable for big file
  should_enable = function(bufnr)
    return not bigfile.is_too_big(bufnr)
  end,
})

-- highlight style
local illuminate_augroup = vim.api.nvim_create_augroup("illuminate_augroup", { clear = true })
vim.api.nvim_create_autocmd({ "UIEnter", "VimEnter", "Colorscheme" }, {
  group = illuminate_augroup,
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
      vim.api.nvim_set_hl(0, "illuminatedWord", cl)
    end)
  end,
})
