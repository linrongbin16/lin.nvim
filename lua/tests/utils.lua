--- @type boolean
local IS_WINDOWS = vim.fn.has("win32") > 0 or vim.fn.has("win64") > 0
--- @type boolean
local IS_MACOS = vim.fn.has("mac")
--- @type string
local PATH_SEPARATOR = IS_WINDOWS and "\\" or "/"

--- @type string
local LOG_NAME = "lin.nvim"
--- @type string
local LOG_FILE = vim.fn.stdpath("data")
    .. PATH_SEPARATOR
    .. "lin-nvim-tests.log"

--- @param msg string
--- @return nil
local function info(msg)
    local msg_lines = vim.split(msg, "\n")
    for _, line in ipairs(msg_lines) do
        vim.cmd(
            string.format('echom "[%s] %s"', LOG_NAME, vim.fn.escape(line, '"'))
        )
    end
    local fp = io.open(LOG_FILE, "a")
    if fp then
        for _, line in ipairs(msg_lines) do
            fp:write(
                string.format(
                    "[%s] %s - %s\n",
                    LOG_NAME,
                    os.date("%Y-%m-%d %H:%M:%S"),
                    line
                )
            )
        end
        fp:close()
    end
end

local M = {
    info = info,
}

return M