-- ======== Init ========

local uv = vim.uv or vim.loop
local stdconfig = vim.fn.stdpath("config")

local function vimloader(handle)
  local vimfile = stdconfig .. string.format("/%s.vim", handle)
  if uv.fs_stat(vimfile) then
    vim.fn.execute(string.format("source %s", vimfile), "silent!")
  end
end

local function lualoader(handle)
  local luafile = stdconfig .. string.format("/lua/%s.lua", handle)
  if uv.fs_stat(luafile) then
    require(handle)
  end
end

-- disable useless builtin plugins
require("builtin.disabled")

-- preinit.vim and preinit.lua
vimloader("preinit")
lualoader("preinit")

-- options
vimloader("lua/builtin/options")
require("builtin.ui")
require("builtin.lsp")
require("builtin.diagnostic")

-- plugins
require("configs.folke.lazy-nvim.config")

-- others
require("builtin.others")

-- postinit.vim and postinit.lua
vimloader("postinit")
lualoader("postinit")
