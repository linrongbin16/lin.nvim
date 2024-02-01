local windline = require("windline")
local helper = require("windline.helpers")
local b_components = require("windline.components.basic")
local HSL = require("wlanimation.utils")
local lsp_comps = require("windline.components.lsp")
local cache_utils = require("windline.cache_utils")
local sep = helper.separators
local state = _G.WindLine.state

local constants = require("builtin.utils.constants")

--- @param highlights string[]
--- @param attr "fg"|"bg"|nil
--- @return string?
local function hl_color(highlights, attr)
    attr = attr or "fg"
    for _, hl in ipairs(highlights) do
        local hl_value = vim.api.nvim_get_hl(0, { name = hl, link = false })
        if type(hl_value) == "table" and type(hl_value[attr]) == "number" then
            return string.format("#%06x", hl_value[attr])
        end
    end
    return nil
end

local hl_list = {
    Black = { "white", "black" },
    White = { "black", "white" },
    Normal = { "NormalFg", "NormalBg" },
    Inactive = { "InactiveFg", "InactiveBg" },
    Active = { "ActiveFg", "ActiveBg" },
}
local basic = {}

local airline_colors = {}

airline_colors.a = {
    NormalSep = { "normal_a", "normal_b" },
    InsertSep = { "insert_a", "insert_b" },
    VisualSep = { "visual_a", "visual_b" },
    ReplaceSep = { "replace_a", "replace_b" },
    CommandSep = { "command_a", "command_b" },
    Normal = { "black", "normal_a" },
    Insert = { "black", "insert_a" },
    Visual = { "black", "visual_a" },
    Replace = { "black", "replace_a" },
    Command = { "black", "command_a" },
}

airline_colors.b = {
    NormalSep = { "normal_b", "normal_c" },
    InsertSep = { "insert_b", "insert_c" },
    VisualSep = { "visual_b", "visual_c" },
    ReplaceSep = { "replace_b", "replace_c" },
    CommandSep = { "command_b", "command_c" },
    Normal = { "white", "normal_b" },
    Insert = { "white", "insert_b" },
    Visual = { "white", "visual_b" },
    Replace = { "white", "replace_b" },
    Command = { "white", "command_b" },
}

airline_colors.c = {
    NormalSep = { "normal_c", "normal_d" },
    InsertSep = { "insert_c", "insert_d" },
    VisualSep = { "visual_c", "visual_d" },
    ReplaceSep = { "replace_c", "replace_d" },
    CommandSep = { "command_c", "command_d" },
    Normal = { "white", "normal_c" },
    Insert = { "white", "insert_c" },
    Visual = { "white", "visual_c" },
    Replace = { "white", "replace_c" },
    Command = { "white", "command_c" },
}

airline_colors.d = {
    NormalSep = { "normal_d", "NormalBg" },
    InsertSep = { "insert_d", "NormalBg" },
    VisualSep = { "visual_d", "NormalBg" },
    ReplaceSep = { "replace_d", "NormalBg" },
    CommandSep = { "command_d", "NormalBg" },
    Normal = { "white", "normal_d" },
    Insert = { "white", "insert_d" },
    Visual = { "white", "visual_d" },
    Replace = { "white", "replace_d" },
    Command = { "white", "command_d" },
    DiffAdd = { "diff_added", "normal_d" },
    DiffModify = { "diff_modified", "normal_d" },
    DiffDelete = { "diff_removed", "normal_d" },
}

basic.divider = { b_components.divider, hl_list.Normal }

-- a \ b \ c  ---  x / y / z
local left_separator = sep.slant_left
local right_separator = sep.slant_right
-- a > b > c  ---  x < y < z
-- local left_separator = sep.left_filled
-- local right_separator = sep.right_filled

local width_breakpoint = 100

local function mode_hl()
    return state.mode[2]
end

local function mode_sep_hl()
    return state.mode[2] .. "Sep"
end

basic.section_a = {
    hl_colors = airline_colors.a,
    text = function(_, _, width)
        if width > width_breakpoint then
            return {
                { " " .. state.mode[1] .. " ", mode_hl() },
                { right_separator, mode_sep_hl() },
            }
        end
        return {
            { " " .. state.mode[1]:sub(1, 1) .. " ", mode_hl() },
            { right_separator, mode_sep_hl() },
        }
    end,
}

basic.section_b = {
    hl_colors = airline_colors.b,
    text = cache_utils.cache_on_buffer(
        {
            "VimEnter",
            "UIEnter",
            "BufEnter",
            "BufNewFile",
            "TermEnter",
            "TermLeave",
            "FocusGained",
            "FocusLost",
            "CmdlineEnter",
            "CmdlineLeave",
        },
        "wl_git_branch",
        function(bufnr, _, width)
            if
                width > width_breakpoint
                and vim.fn.exists("*gitbranch#name") > 0
            then
                local branch = vim.fn["gitbranch#name"]()
                if type(branch) == "string" and string.len(branch) > 0 then
                    return {
                        { "  ", mode_hl() },
                        { vim.fn["gitbranch#name"](), "" },
                        { " " },
                        { right_separator, mode_sep_hl() },
                    }
                end
            end
            return { { right_separator, mode_sep_hl() } }
        end
    ),
}

local function get_buf_name(modify, shorten)
    return function(bufnr)
        local bufname = vim.fn.bufname(bufnr)
        bufname = vim.fn.fnamemodify(bufname, modify)
        if shorten then
            return vim.fn.pathshorten(bufname)
        end
        return bufname
    end
end

local function file_name()
    local fnc_name = get_buf_name("%:p", true)
    return function(bufnr)
        local name = fnc_name(bufnr)
        if name == "" then
            name = "[No Name]"
        end
        return name .. " "
    end
end

local function file_status()
    local modified = "" -- Text to show when the file is modified.
    local readonly = "" -- Text to show when the file is non-modifiable or readonly.
    local builder = ""
    if vim.bo.modified then
        builder = builder .. modified
    end
    if vim.bo.modifiable == false or vim.bo.readonly == true then
        builder = builder .. readonly
    end
    return string.len(builder) > 0 and "[" .. builder .. "]" or ""
end

local function file_size(opt)
    opt = opt or {}

    local unit_factor = opt.base == nil and 1000
        or opt.base == 10 and 1000
        or opt.base == 2 and 1024

    local clamped_precision = opt.precision == nil and 2
        or opt.precision < 0 and 0
        or opt.precision > 16 and 16
        or opt.precision

    local precision_factor = math.pow(10, clamped_precision)

    local suffixes = {
        "B",
        "kB",
        "MB",
        "GB",
        "TB",
        "PB",
        "EB",
    }

    return function()
        local path = vim.api.nvim_buf_get_name(0)

        if string.len(path) == 0 then
            return ""
        end

        local size = vim.fn.getfsize(path)

        if size < 1 then
            return ""
        end

        local index = 1

        while size >= unit_factor and index < #suffixes do
            size = size / unit_factor
            index = index + 1
        end

        local rounded_size = math.ceil(size * precision_factor - 0.5)
            / precision_factor

        return "[" .. rounded_size .. suffixes[index] .. "]"
    end
end

basic.section_c = {
    hl_colors = airline_colors.c,
    text = function()
        return {
            { " ", mode_hl() },
            {
                cache_utils.cache_on_buffer(
                    "BufEnter",
                    "wl_file_name",
                    file_name()
                ),
            },
            { file_status },
            {
                cache_utils.cache_on_buffer(
                    "BufWritePost",
                    "WL_filesize",
                    file_size()
                ),
            },
            { " " },
            { right_separator, mode_sep_hl() },
        }
    end,
}

basic.section_d = {
    hl_colors = airline_colors.d,
    text = function(_, _, width)
        if
            width > width_breakpoint
            and vim.fn.exists("*GitGutterGetHunkSummary") > 0
        then
            local summary = vim.fn.GitGutterGetHunkSummary() or {}
            local signs = { "+", "~", "-" }
            local colors = { "DiffAdd", "DiffModify", "DiffDelete" }
            local components = { { " ", mode_hl() } }
            local has_changes = false
            for i, v in ipairs(summary) do
                if type(v) == "number" and v > 0 then
                    table.insert(
                        components,
                        { string.format("%s%s ", signs[i], v), colors[i] }
                    )
                    has_changes = true
                end
            end
            if has_changes then
                -- table.insert(components, { " " })
                table.insert(components, { right_separator, mode_sep_hl() })
                return components
            end
        end
        return { { right_separator, mode_sep_hl() } }
    end,
}

local FILE_FORMAT_ICONS = {
    unix = "", -- e712
    dos = "", -- e70f
    mac = "", -- e711
}

local function file_format()
    return function()
        local bff = vim.bo.fileformat
        if FILE_FORMAT_ICONS[bff] then
            return FILE_FORMAT_ICONS[bff] .. " " .. bff
        else
            return bff
        end
    end
end

local function file_encoding()
    return function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
        return enc:lower()
    end
end

basic.section_w = {
    hl_colors = airline_colors.d,
    text = function(_, _, width)
        if width > width_breakpoint then
            return {
                { left_separator, mode_sep_hl() },
                { " ", mode_hl() },
                { file_encoding() },
                { " " },
            }
        end
        return {
            { left_separator, mode_sep_hl() },
        }
    end,
}

basic.section_x = {
    hl_colors = airline_colors.c,
    text = function(_, _, width)
        if width > width_breakpoint then
            return {
                { left_separator, mode_sep_hl() },
                { " ", mode_hl() },
                { file_format() },
                { " " },
            }
        end
        return {
            { left_separator, mode_sep_hl() },
        }
    end,
}

basic.section_y = {
    hl_colors = airline_colors.b,
    text = function(_, _, width)
        if width > width_breakpoint then
            return {
                { left_separator, mode_sep_hl() },
                { " ", mode_hl() },
                {
                    b_components.cache_file_type({ icon = true }),
                    "",
                },
                { " " },
            }
        end
        return { { left_separator, mode_sep_hl() } }
    end,
}

local LINENO_COLUMN = [[ %2l:%-2c ]]
-- local LINENO_PROGRESS = [[%2p%% ]]

local function lineno_progress()
    local line_fraction = math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)
    if line_fraction >= 100 then
        return "Bot "
    elseif line_fraction <= 0 then
        return "Top "
    else
        return string.format("%2d%%%% ", line_fraction)
    end
end

basic.section_z = {
    hl_colors = airline_colors.a,
    text = function(_, _, width)
        if width > width_breakpoint then
            return {
                { left_separator, mode_sep_hl() },
                { " ", mode_hl() },
                { LINENO_COLUMN },
                { " " },
                { lineno_progress },
            }
        end
        return {
            { left_separator, mode_sep_hl() },
            { " ", mode_hl() },
            { LINENO_COLUMN, mode_hl() },
        }
    end,
}

basic.diagnostic = {
    name = "diagnostic",
    hl_colors = {
        diagnostic_err = { "diagnostic_err", "NormalBg" },
        diagnostic_warn = { "diagnostic_warn", "NormalBg" },
        diagnostic_info = { "diagnostic_info", "NormalBg" },
        diagnostic_hint = { "diagnostic_hint", "NormalBg" },
    },
    text = function(bufnr)
        if lsp_comps.check_lsp(bufnr) then
            return {
                {
                    lsp_comps.lsp_error({
                        format = " "
                            .. constants.diagnostic.sign.error
                            .. " %s",
                        show_zero = false,
                    }),
                    "diagnostic_err",
                },
                {
                    lsp_comps.lsp_warning({
                        format = " "
                            .. constants.diagnostic.sign.warning
                            .. " %s",
                        show_zero = false,
                    }),
                    "diagnostic_warn",
                },
                {
                    lsp_comps.lsp_info({
                        format = " " .. constants.diagnostic.sign.info .. " %s",
                        show_zero = false,
                    }),
                    "diagnostic_info",
                },
                {
                    lsp_comps.lsp_hint({
                        format = " " .. constants.diagnostic.sign.hint .. " %s",
                        show_zero = false,
                    }),
                    "diagnostic_hint",
                },
                {
                    " ",
                    "diagnostic_err",
                },
            }
        end
        return { " ", "diagnostic_err" }
    end,
}

basic.lspstatus = {
    name = "lspstatus",
    hl_colors = {
        white = { "white", "NormalBg" },
    },
    text = function(bufnr, _, width)
        local status = require("lsp-progress").progress()
        if type(status) == "string" and string.len(status) > 0 then
            return { "", { " " .. status, "white" } }
        else
            return ""
        end
    end,
}

basic.searchcount = {
    name = "searchcount",
    width = width_breakpoint,
    text = function()
        if vim.v.hlsearch == 0 then
            return ""
        end

        local check, result = pcall(vim.fn.searchcount, { recompute = 0 })
        if not check or not result or result.current == nil then
            return ""
        end

        if result.total == 0 and result.current == 0 then
            return ""
        end

        if result.incomplete == 1 then -- timed out
            return " [?/??] "
        elseif result.incomplete == 2 then -- max count exceeded
            if
                result.total > result.maxcount
                and result.current > result.maxcount
            then
                return string.format(
                    " [>%d/>%d] ",
                    result.current,
                    result.total
                )
            elseif result.total > result.maxcount then
                return string.format(" [%d/>%d] ", result.current, result.total)
            end
        end
        return string.format(
            " [%d/%d] ",
            result.current or "",
            result.total or ""
        )
    end,
}

local quickfix = {
    filetypes = { "qf", "Trouble" },
    active = {
        { "🚦 Quickfix ", { "white", "black" } },
        { helper.separators.slant_right, { "black", "black_light" } },
        {
            function()
                return vim.fn.getqflist({ title = 0 }).title
            end,
            { "cyan", "black_light" },
        },
        { " Total : %L ", { "cyan", "black_light" } },
        { helper.separators.slant_right, { "black_light", "InactiveBg" } },
        { " ", { "InactiveFg", "InactiveBg" } },
        basic.divider,
        { helper.separators.slant_right, { "InactiveBg", "black" } },
        { "🧛 ", { "white", "black" } },
    },
    always_active = true,
    show_last_status = true,
}

local explorer = {
    filetypes = { "fern", "NvimTree", "lir" },
    active = {
        { "  ", { "white", "normal_b" } },
        { helper.separators.slant_right, { "normal_b", "NormalBg" } },
        { b_components.divider, "" },
        { b_components.file_name(""), { "NormalFg", "NormalBg" } },
    },
    always_active = true,
    show_last_status = true,
}

local default = {
    filetypes = { "default" },
    active = {
        basic.section_a,
        basic.section_b,
        basic.section_c,
        basic.section_d,
        basic.lspstatus,
        basic.divider,
        basic.searchcount,
        basic.diagnostic,
        basic.section_w,
        basic.section_x,
        basic.section_y,
        basic.section_z,
    },
    inactive = {
        { b_components.full_file_name, hl_list.Inactive },
        { b_components.divider, hl_list.Inactive },
        { b_components.line_col, hl_list.Inactive },
        { b_components.progress, hl_list.Inactive },
    },
}

windline.setup({
    colors_name = function(colors)
        local mod = function(c, value)
            if vim.o.background == "light" then
                return HSL.rgb_to_hsl(c):tint(value):to_rgb()
            end
            return HSL.rgb_to_hsl(c):shade(value):to_rgb()
        end
        local def = function(name, factors)
            local n = #factors
            for i = 1, n do
                colors[name .. "_" .. ("").char(i + 96)] = i == 1
                        and colors[name]
                    or mod(colors[name], factors[i])
            end
        end

        local factors = { 1, 0.4, 0.55, 0.7 }
        colors.normal = hl_color({ "Directory", "Special" }) or colors.magenta
        def("normal", factors)

        colors.insert = hl_color({ "GitGutterAdd", "diffAdded", "DiffAdd" })
            or colors.green
        def("insert", factors)

        colors.visual = hl_color({ "IncSearch" }, "bg") or colors.yellow
        def("visual", factors)

        colors.replace = hl_color({ "Constant" }) or colors.blue
        def("replace", factors)

        colors.command = hl_color({
            "Constant",
        }) or colors.red
        def("command", factors)

        colors.diff_added = hl_color({ "GitGutterAdd", "diffAdded", "DiffAdd" })
            or colors.green
        colors.diff_modified = hl_color({
            "GitGutterChange",
            "diffChanged",
            "DiffChange",
        }) or colors.blue
        colors.diff_removed = hl_color({
            "GitGutterDelete",
            "diffRemoved",
            "DiffDelete",
        }) or colors.red

        colors.diagnostic_err = hl_color({
            "DiagnosticSignError",
            "LspDiagnosticsSignError",
            "ErrorMsg",
        }) or colors.red
        colors.diagnostic_warn = hl_color({
            "DiagnosticSignWarn",
            "LspDiagnosticsSignWarn",
            "WarningMsg",
        }) or colors.yellow
        colors.diagnostic_info = hl_color({
            "DiagnosticSignInfo",
            "LspDiagnosticsSignInfo",
        }) or colors.cyan
        colors.diagnostic_hint = hl_color({
            "DiagnosticSignHint",
            "LspDiagnosticsSignHint",
            "Comment",
        }) or colors.blue

        colors.white = hl_color({ "Normal" }) or "NormalFg"
        colors.black = hl_color({ "Normal" }, "bg") or "NormalBg"

        return colors
    end,
    statuslines = {
        default,
        quickfix,
        explorer,
    },
})
