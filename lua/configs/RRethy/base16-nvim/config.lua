local str = require("commons.str")

local rtp = vim.fn.escape(vim.o.runtimepath, " ")
local colorfiles = vim.fn.globpath(rtp, "colors/*.vim", 0, 1)
local n = #colorfiles
local ts = os.time()
local r = math.fmod(ts, n)

local colorfile = colorfiles[r]
local color = vim.fn.fnamemodify(colorfile, ":t:r")
-- vim.defer_fn(function()
--   print(string.format("r:%s,f:%s,c:%s", vim.inspect(r), vim.inspect(colorfile), vim.inspect(color)))
-- end, 1000)

while str.endswith(color, "-light") or str.endswith(color, "-day") do
  r = math.fmod(r + 1, n)
  colorfile = colorfiles[r]
  color = vim.fn.fnamemodify(colorfile, ":t:r")
  -- vim.defer_fn(function()
  --   print(
  --     string.format("r:%s,f:%s,c:%s", vim.inspect(r), vim.inspect(colorfile), vim.inspect(color))
  --   )
  -- end, 2000)
end

vim.cmd("colorscheme " .. color)
