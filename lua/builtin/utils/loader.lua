local function load(path)
    if path:sub(-4) == ".lua" then
        local path2 = path:sub(1, #path - 4):gsub("/", "%.")
        return pcall(require, path2)
    elseif path:sub(-4) == ".vim" then
        if path:sub(1, 1) ~= "/" and path:sub(1, 1) ~= "\\" then
            vim.cmd(string.format("source $HOME/.nvim/%s", path))
        else
            vim.cmd(string.format("source $HOME/.nvim%s", path))
        end
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