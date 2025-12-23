local str = require("commons.str")

local rtp = vim.fn.escape(vim.o.runtimepath, " ")
local colorfiles = vim.fn.globpath(rtp, "colors/*.vim", 0, 1)
local n = #colorfiles
local ts = os.time()
local r = math.fmod(ts, n)

local colorfile = colorfiles[r]
local color = vim.fn.fnamemodify(colorfile, ":t:r")
print(string.format("r:%s,f:%s,c:%s", vim.inspect(r), vim.inspect(colorfile), vim.inspect(color)))

while str.endswith(colorfile, "-light") or str.endswith(colorfile, "-day") do
  r = math.fmod(r + 1, n)
  colorfile = colorfiles[r]
  color = vim.fn.fnamemodify(colorfile, ":t:r")
  print(string.format("r:%s,f:%s,c:%s", vim.inspect(r), vim.inspect(colorfile), vim.inspect(color)))
end

vim.cmd("colorscheme " .. color)
