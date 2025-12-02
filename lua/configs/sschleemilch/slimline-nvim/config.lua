local str = require("commons.str")

local function LspProgress()
  local status = require("lsp-progress").progress()
  if str.not_empty(status) then
    return " " .. status
  else
    return ""
  end
end

require("slimline").setup({
  components = {
    left = {
      "mode",
      "path",
      "git",
      LspProgress,
    },
    center = {},
    right = {
      "diagnostics",
      "filetype_lsp",
      "progress",
    },
  },
  configs = {
    mode = {
      verbose = true,
    },
  },
  progress = {
    column = true, -- Enables a secondary section with the cursor column
  },
  spaces = {
    components = "",
    left = "",
    right = "",
  },
  sep = {
    hide = {
      first = true,
      last = true,
    },
    left = "",
    right = "",
  },
})

-- listen to lsp-progress event and refresh
local slimline_augroup = vim.api.nvim_create_augroup("slimline_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = slimline_augroup,
  pattern = { "LspProgressStatusUpdated", "GitGutter", "GitGutterStage" },
  callback = function()
    vim.schedule(function()
      vim.cmd.redrawstatus()
    end)
  end,
})
vim.api.nvim_create_autocmd({
  "BufReadPre",
  "BufNewFile",
  "BufEnter",
  "VimEnter",
  "WinEnter",
  "LspAttach",
  "FocusGained",
  "FocusLost",
  "TermLeave",
  "TermClose",
  "DirChanged",
  "BufWritePost",
  "FileWritePost",
}, {
  group = slimline_augroup,
  callback = function()
    vim.schedule(function()
      vim.cmd.redrawstatus()
    end)
  end,
})
