--- @param hl string
--- @param fmt string
--- @param ... any?
local function echo(hl, fmt, ...)
    local msg = string.format(fmt, ...)
    local lines = vim.split(msg, "\n", { plain = true })
    local prefix = ""
    if hl == "ErrorMsg" then
        prefix = "error! "
    elseif hl == "WarningMsg" then
        prefix = "warning! "
    end
    for _, line in ipairs(lines) do
        local chunks = {}
        table.insert(chunks, {
            string.format("[lin.nvim] %s%s", prefix, line),
            hl,
        })
        vim.schedule(function()
            vim.api.nvim_echo(chunks, false, {})
        end)
    end
end

--- @param fmt string
--- @param ... any?
local function info(fmt, ...)
    echo("None", fmt, ...)
end

--- @param fmt string
--- @param ... any?
local function warn(fmt, ...)
    echo("WarningMsg", fmt, ...)
end

--- @param fmt string
--- @param ... any?
local function err(fmt, ...)
    echo("ErrorMsg", fmt, ...)
end

--- @param fmt string
--- @param ... any?
local function throw(fmt, ...)
    echo("ErrorMsg", fmt, ...)
    error(string.format(fmt, ...))
end

--- @param cond boolean
--- @param fmt string
--- @param ... any?
local function ensure(cond, fmt, ...)
    if not cond then
        throw(fmt, ...)
    end
end

local M = {
    info = info,
    warn = warn,
    err = err,
    throw = throw,
    ensure = ensure,
}

return M
