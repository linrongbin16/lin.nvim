--- @param msg string
--- @return nil
local function warn(msg)
    vim.cmd([[
    echohl WarningMsg
    echomsg "[lin.nvim] Warning! ]] .. msg .. [["
    echohl None
    ]])
end

--- @param msg string
--- @return nil
local function err(msg)
    error("[lin.nvim] Error! " .. msg)
end

--- @type LuaModule
local M = {
    warn = warn,
    err = err,
}

return M