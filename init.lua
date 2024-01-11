-- ======== Init ========

local uv = vim.uv or vim.loop
local stdpath_config = vim.fn.stdpath("config")

local function vimloader(handle)
    local vimfile = stdpath_config .. string.format("/%s.vim", handle)
    if uv.fs_stat(vimfile) then
        vim.fn.execute(string.format("source %s", vimfile), true)
    end
end

local function lualoader(handle)
    local luafile = stdpath_config .. string.format("/lua/%s.lua", handle)
    if uv.fs_stat(luafile) then
        require(handle)
    end
end

-- preinit.vim and preinit.lua
vimloader("preinit")
lualoader("preinit")

-- options
require("builtin.options")
require("builtin.lsp")

-- plugins
require("configs.folke.lazy-nvim.config")

-- others
require("builtin.others")

-- postinit.vim and postinit.lua
vimloader("postinit")
lualoader("postinit")
