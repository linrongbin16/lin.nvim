local windline = require("windline")
local helper = require("windline.helpers")
local sep = helper.separators
local b_components = require("windline.components.basic")
local state = _G.WindLine.state
local vim_components = require("windline.components.vim")
local HSL = require("wlanimation.utils")

local lsp_comps = require("windline.components.lsp")
local git_comps = require("windline.components.git")

local cache_utils = require("windline.cache_utils")

local constants = require("builtin.utils.constants")

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
    NormalSep = { "magenta_a", "magenta_b" },
    InsertSep = { "green_a", "green_b" },
    VisualSep = { "yellow_a", "yellow_b" },
    ReplaceSep = { "blue_a", "blue_b" },
    CommandSep = { "red_a", "red_b" },
    Normal = { "black", "magenta_a" },
    Insert = { "black", "green_a" },
    Visual = { "black", "yellow_a" },
    Replace = { "black", "blue_a" },
    Command = { "black", "red_a" },
}

airline_colors.b = {
    NormalSep = { "magenta_b", "magenta_c" },
    InsertSep = { "green_b", "green_c" },
    VisualSep = { "yellow_b", "yellow_c" },
    ReplaceSep = { "blue_b", "blue_c" },
    CommandSep = { "red_b", "red_c" },
    Normal = { "white", "magenta_b" },
    Insert = { "white", "green_b" },
    Visual = { "white", "yellow_b" },
    Replace = { "white", "blue_b" },
    Command = { "white", "red_b" },
}

airline_colors.c = {
    NormalSep = { "magenta_c", "NormalBg" },
    InsertSep = { "green_c", "NormalBg" },
    VisualSep = { "yellow_c", "NormalBg" },
    ReplaceSep = { "blue_c", "NormalBg" },
    CommandSep = { "red_c", "NormalBg" },
    Normal = { "white", "magenta_c" },
    Insert = { "white", "green_c" },
    Visual = { "white", "yellow_c" },
    Replace = { "white", "blue_c" },
    Command = { "white", "red_c" },
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
    width = width_breakpoint,
    text = cache_utils.cache_on_buffer(
        {
            "BufEnter",
            "BufNewFile",
            "BufLeave",
            "TermEnter",
            "TermLeave",
            "TermOpen",
            "TermClose",
            "FocusGained",
            "FocusLost",
            "CmdlineEnter",
            "CmdlineLeave",
            "WinEnter",
            "WinLeave",
        },
        "windline_nvim_git_branch",
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
                        { " ", "" },
                        { right_separator, mode_sep_hl() },
                    }
                end
            end
            return { { right_separator, mode_sep_hl() } }
        end
    ),
}

basic.section_c = {
    hl_colors = airline_colors.c,
    text = function()
        return {
            { " ", mode_hl() },
            { b_components.cache_file_name("[No Name]", "unique") },
            { " " },
            { right_separator, mode_sep_hl() },
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
                { b_components.file_encoding() },
                { " " },
                { b_components.file_format({ icon = true }) },
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
                { " ", "" },
            }
        end
        return { { left_separator, mode_sep_hl() } }
    end,
}

local LINENO_COLUMN = [[ %2l:%-2c ]]
local LINENO_PROGRESS = [[%3p%% ]]

basic.section_z = {
    hl_colors = airline_colors.a,
    text = function(_, _, width)
        if width > width_breakpoint then
            return {
                { left_separator, mode_sep_hl() },
                { " ", mode_hl() },
                { LINENO_COLUMN },
                { "" },
                { LINENO_PROGRESS },
            }
        end
        return {
            { left_separator, mode_sep_hl() },
            { " ", mode_hl() },
            { LINENO_COLUMN, mode_hl() },
        }
    end,
}

basic.lsp_diagnos = {
    name = "diagnostic",
    hl_colors = {
        red = { "red", "NormalBg" },
        yellow = { "yellow", "NormalBg" },
        blue = { "blue", "NormalBg" },
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
                    "red",
                },
                {
                    lsp_comps.lsp_warning({
                        format = " "
                            .. constants.diagnostic.sign.warning
                            .. " %s",
                        show_zero = false,
                    }),
                    "yellow",
                },
                {
                    lsp_comps.lsp_info({
                        format = " " .. constants.diagnostic.sign.info .. " %s",
                        show_zero = false,
                    }),
                    "cyan",
                },
                {
                    lsp_comps.lsp_hint({
                        format = " " .. constants.diagnostic.sign.hint .. " %s",
                        show_zero = false,
                    }),
                    "blue",
                },
                {
                    " ",
                    "red",
                },
            }
        end
        return { " ", "red" }
    end,
}

basic.git_changes = {
    name = "git_changes",
    width = width_breakpoint,
    hl_colors = {
        green = { "green", "NormalBg" },
        red = { "red", "NormalBg" },
        blue = { "blue", "NormalBg" },
    },
    text = function(bufnr)
        if git_comps.is_git(bufnr) then
            return {
                { git_comps.diff_added({ format = "  %s" }), "green" },
                { git_comps.diff_removed({ format = "  %s" }), "red" },
                { git_comps.diff_changed({ format = "  %s" }), "blue" },
            }
        end
        return ""
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
        { "  ", { "white", "magenta_b" } },
        { helper.separators.slant_right, { "magenta_b", "NormalBg" } },
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
        basic.git_changes,
        basic.divider,
        { vim_components.search_count(), { "cyan", "NormalBg" } },
        basic.lsp_diagnos,
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

        colors.magenta_a = colors.magenta
        colors.magenta_b = mod(colors.magenta, 0.5)
        colors.magenta_c = mod(colors.magenta, 0.7)
        colors.magenta_d = mod(colors.magenta, 0.85)

        colors.yellow_a = colors.yellow
        colors.yellow_b = mod(colors.yellow, 0.5)
        colors.yellow_c = mod(colors.yellow, 0.7)
        colors.yellow_d = mod(colors.yellow, 0.85)

        colors.blue_a = colors.blue
        colors.blue_b = mod(colors.blue, 0.5)
        colors.blue_c = mod(colors.blue, 0.7)
        colors.blue_d = mod(colors.blue, 0.85)

        colors.green_a = colors.green
        colors.green_b = mod(colors.green, 0.5)
        colors.green_c = mod(colors.green, 0.7)
        colors.green_d = mod(colors.green, 0.85)

        colors.red_a = colors.red
        colors.red_b = mod(colors.red, 0.5)
        colors.red_c = mod(colors.red, 0.7)
        colors.red_d = mod(colors.red, 0.85)

        return colors
    end,
    statuslines = {
        default,
        quickfix,
        explorer,
    },
})
