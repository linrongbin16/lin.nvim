local function load(path)
    if path:sub(-4) == ".lua" then
        return pcall(require, path:sub(1, #path - 4))
    elseif path:sub(-4) == ".vim" then
        vim.cmd(string.format("source $HOME/.nvim/%s", path))
        return true, path
    else
        print("Error! module '" .. path .. "' must be a lua or vim file!")
        return false, nil
    end
end

local M = {
    load = load,
}

return M