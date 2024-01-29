local editor = {
    --- @param percent number
    --- @param min_width integer?
    --- @param max_width integer?
    --- @return integer
    width = function(percent, min_width, max_width)
        local editor_w = vim.o.columns
        local result = math.floor(editor_w * percent)
        if max_width then
            result = math.floor(math.min(max_width, result))
        end
        if min_width then
            result = math.floor(math.max(min_width, result))
        end
        return result
    end,

    --- @param percent number
    --- @param min_height integer
    --- @param max_height integer
    --- @return integer
    height = function(percent, min_height, max_height)
        local editor_h = vim.o.lines
        local result = math.floor(editor_h * percent)
        if max_height then
            result = vim.fn.min({ max_height, result })
        end
        if min_height then
            result = vim.fn.max({ min_height, result })
        end
        return result
    end,
}

local M = {
    editor = editor,
}

return M
