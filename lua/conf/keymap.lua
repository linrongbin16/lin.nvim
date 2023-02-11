-- ---- Key Map ----

local NON_EDIT_FTYPES = { "neo-tree", "NvimTree", "undotree", "vista", "diff" }
local function non_editable(ft)
    for _, value in ipairs(NON_EDIT_FTYPES) do
        if value == ft then
            return true
        end
    end
    return false
end
local function exec_impl(o)
    if type(o) == "string" then
        -- vim command
        vim.cmd(o)
    else
        -- lua function
        o()
    end
end
local function exec(cmd)
    local function wrap()
        local n = vim.fn.winnr("$")
        local i = 0
        while i < n do
            i = i + 1
            if non_editable(vim.bo.filetype) then
                -- current buffer non editable
                -- go to next buffer
                vim.cmd("wincmd w")
            else
                exec_impl(cmd)
                return
            end
        end
        -- finally doesn't find an editable buffer
        -- execute command anyway
        exec_impl(cmd)
    end
    return wrap
end

local DEFAULT_OPTS = {
    silent = true,
    noremap = true, -- automatically set false for <Plug>
    -- buffer = false,
}

local function map(mode, lhs, rhs, opts)
    opts = vim.tbl_deep_extend("force", DEFAULT_OPTS, opts or {})
    if type(rhs) == "string" and string.len(rhs) >= 6 and string.sub(rhs, 1, 6) == "<plug>" then
        opts.noremap = false
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

local M = {
    exec = exec,
    map = map,
}

return M
