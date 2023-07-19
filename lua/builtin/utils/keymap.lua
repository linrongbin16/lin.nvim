-- ---- Key Map ----

--- @type string[]
local NON_EDITABLE_FIELTYPES = {
    ["neo-tree"] = true,
    ["NvimTree"] = true,
    ["undotree"] = true,
    ["vista"] = true,
    ["diff"] = true,
    ["CHADTree"] = true,
}

--- @return boolean
local function invalid_window()
    local buf_filetype = vim.bo.filetype
    return NON_EDITABLE_FIELTYPES[buf_filetype] ~= nil
        and NON_EDITABLE_FIELTYPES[buf_filetype] == true
end

--- @param cmd VimKeymapRhs
--- @return VimKeymapRhs
local function exec(cmd)
    --- @param o VimKeymapRhs
    --- @return nil
    local function exec_impl(o)
        if type(o) == "string" then
            -- vim command
            vim.cmd(o)
        else
            -- lua function
            o()
        end
    end

    --- @return nil
    local function wrap()
        local n = vim.fn.winnr("$")
        local i = 0
        while i < n do
            i = i + 1
            if invalid_window() then
                -- current window is invalid
                -- go to next window
                vim.cmd("wincmd w")
            else
                exec_impl(cmd)
                return
            end
        end
        -- finally cannot find a valid window
        -- execute command anyway
        exec_impl(cmd)
    end

    return wrap
end

--- @type VimKeymapOpts
local DEFAULT_OPTS = {
    silent = true,
    noremap = true,
    -- buffer = false,
}

--- @param rhs VimKeymapRhs
--- @param opts VimKeymapOpts
--- @return VimKeymapOpts
local function make_opts(rhs, opts)
    opts = vim.tbl_deep_extend("force", DEFAULT_OPTS, opts or {})
    -- forcibly set `noremap=false` for <Plug>
    if
        type(rhs) == "string"
        and string.len(rhs) >= 6
        and string.sub(rhs, 1, 6):lower() == "<plug>"
    then
        opts.noremap = false
    end
    return opts
end

--- @param mode string|string[]
--- @param lhs VimKeymapLhs
--- @param rhs VimKeymapRhs
--- @param opts VimKeymapOpts
--- @return nil
local function set_key(mode, lhs, rhs, opts)
    --- @type VimKeymapOpts
    opts = make_opts(rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
end

--- @param mode string|string[]
--- @param lhs VimKeymapLhs
--- @param rhs VimKeymapRhs
--- @param opts VimKeymapOpts
--- @return LazyKeySpec
local function set_lazy_key(mode, lhs, rhs, opts)
    opts = make_opts(rhs, opts)
    --- @type LazyKeySpec
    local key_spec = { lhs, rhs, mode = mode }
    for k, v in pairs(opts) do
        key_spec[k] = v
    end
    return key_spec
end

--- @type LuaModule
local M = {
    exec = exec,
    set_key = set_key,
    set_lazy_key = set_lazy_key,
}

return M