-- ---- Other Options ----

local keymap = require("api.keymap")
local std = require("api.std")

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
local prelude_misc = std.create_augroup("prelude_misc", { clear = true })
std.create_autocmd("BufReadPre", {
  group = prelude_misc,
  callback = function(event)
    local perf = require("api.perf")
    if
      type(event) == "table"
      and type(event.buf) == "number"
      and perf.file_is_too_big(event.buf)
    then
      perf.make_file_quick(event.buf)
    end
  end,
})
