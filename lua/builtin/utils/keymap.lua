-- ---- key map ----

local NON_EDIT_FTYPES = { "neo-tree", "NvimTree", "undotree", "vista", "diff" }

local function non_editable(ft)
    for _, value in ipairs(NON_EDIT_FTYPES) do
        if value == ft then
            return true
        end
    end
    return false
end

local function exec(cmd)
    local function exec_impl(o)
        if type(o) == "string" then
            -- vim command
            vim.cmd(o)
        else
            -- lua function
            o()
        end
    end

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
    noremap = true,
    -- buffer = false,
}

local function make_opts(rhs, opts)
    opts = vim.tbl_deep_extend("force", DEFAULT_OPTS, opts or {})
    -- forcibly set `noremap=false` for <Plug>
    if
        type(rhs) == "string"
        and string.len(rhs) >= 6
        and string.sub(rhs, 1, 6) == "<plug>"
    then
        opts.noremap = false
    end
    return opts
end

local function set_key(mode, lhs, rhs, opts)
    opts = make_opts(rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
end

local function set_lazy_key(mode, lhs, rhs, opts)
    opts = make_opts(rhs, opts)
    local key = { lhs, rhs, mode = mode }
    for k, v in pairs(opts) do
        key[k] = v
    end
    return key
end

local M = {
    exec = exec,
    set_key = set_key,
    set_lazy_key = set_lazy_key,
}

return M