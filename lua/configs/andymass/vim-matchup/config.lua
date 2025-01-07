local constants = require("builtin.constants")

local matchup_augroup = vim.api.nvim_create_augroup("matchup_augroup", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  group = matchup_augroup,
  callback = function(event)
    vim.cmd([[NoMatchParen]])
    if type(event) == "table" and type(event.buf) == "number" then
      local f = vim.api.nvim_buf_get_name(event.buf)
      if vim.fn.getfsize(f) <= constants.perf.maxfilesize then
        vim.cmd([[DoMatchParen]])
      end
    end
  end,
})
