local function load(path)
    if path:sub(-#".lua") == ".lua" then
        return pcall(require, path)
    else
        vim.cmd(string.format("source %s", path))
        return true, path
    end
end

local M = {
    load = load,
}

return M