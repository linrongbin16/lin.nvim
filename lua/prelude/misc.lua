-- ---- Other Options ----

local keymap = require("util.keymap")

-- biscuits
keymap.set("n", "@", "<Noq>", { silent = true, desc = "Disable macro recording" })
keymap.set(
  { "n", "x" },
  "<leader>ww",
  ":noa w<CR>",
  { silent = false, desc = "Save file without formatting" }
)
keymap.set({ "n", "x" }, "<leader>qq", ":qall!<CR>", { silent = false, desc = ":qall!" })
keymap.set(
  { "n", "x" },
  "<leader>zz",
  "@=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>",
  { silent = false, desc = "Toggle folding" }
)
keymap.set(
  "x",
  "<leader>yy",
  ":w! " .. vim.fn.stdpath("config") .. "/.copypaste<CR>",
  { silent = false, desc = "Copy visual selected to cache" }
)
keymap.set(
  "n",
  "<leader>pp",
  ":r " .. vim.fn.stdpath("config") .. "/.copypaste<CR>",
  { silent = false, desc = "Paste from cache" }
)

-- large file performance
local builtin_others_augroup =
  vim.api.nvim_create_augroup("builtin_others_augroup", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  group = builtin_others_augroup,
  callback = function(event)
    local bigfile = require("util.bigfile")
    if type(event) == "table" and type(event.buf) == "number" and bigfile.is_too_big(event.buf) then
      bigfile.make_file_quick(event.buf)
    end
  end,
})
