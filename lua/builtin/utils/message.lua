local function warn(msg)
    vim.cmd([[
    echohl WarningMsg
    echomsg "[lin.nvim] Warning! ]] .. msg .. [["
    echohl None
    ]])
end
local function err(msg)
    error("[lin.nvim] Error! " .. msg)
end

local M = {
    warn = warn,
    err = err,
}

return M