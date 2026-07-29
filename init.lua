-- ======== Init ========

local std = require("api.std")
local stdpath_config = vim.fn.stdpath("config")

local function vimloader(handle)
  local vimfile = stdpath_config .. string.format("/%s.vim", handle)
  if std.fs_stat(vimfile) then
    vim.fn.execute(string.format("source %s", vimfile), "silent!")
  end
end

local function lualoader(handle)
  local luafile = stdpath_config .. string.format("/lua/%s.lua", handle)
  if std.fs_stat(luafile) then
    require(handle)
  end
end

-- disable useless builtins
require("prelude.disabled")

-- preinit.vim and preinit.lua
vimloader("preinit")
lualoader("preinit")

-- options
vimloader("lua/prelude/option")
require("prelude.ui")
require("prelude.lsp")
require("prelude.diagnostic")

-- plugins
require("configs.folke.lazy-nvim.config")

-- others
require("prelude.misc")

-- postinit.vim and postinit.lua
vimloader("postinit")
lualoader("postinit")
