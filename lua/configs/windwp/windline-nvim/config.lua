local windline = require("windline")
local helper = require("windline.helpers")
local sep = helper.separators
local b_components = require("windline.components.basic")
local vim_components = require("windline.components.vim")
local HSL = require("wlanimation.utils")

local lsp_comps = require("windline.components.lsp")
local git_comps = require("windline.components.git")

local colors_hl = require("commons.colors.hl")
local colors_hsl = require("commons.colors.hsl")
local strings = require("commons.strings")
local uv = require("commons.uv")

-- slant_left = '',
-- slant_left_thin = '',
-- slant_right = '',
-- slant_right_thin = '',
-- slant_left_2 = '',
-- slant_left_2_thin = '',
-- slant_right_2 = '',
-- slant_right_2_thin = '',
local LEFT_SEP = sep.slant_left
local RIGHT_SEP = sep.slant_right

local state = _G.WindLine.state

local function GetModeName()
    return state.mode[1]
end

--- @param with_sep boolean?
local function GetHl(with_sep)
    return with_sep and state.mode[2] .. "Sep" or state.mode[2]
end

local HIGHLIGHTS = {
    Black = { "white_text", "black_text" },
    White = { "black_text", "white_text" },
    Normal = { "NormalFg", "NormalBg" },
    Inactive = { "InactiveFg", "InactiveBg" },
    Active = { "ActiveFg", "ActiveBg" },
}
local basic = {}

local airline_colors = {}

local Highlight_A = {
    NormalSep = { "normal_bg1", "normal_bg2" },
    InsertSep = { "green_a", "green_b" },
    VisualSep = { "yellow_a", "yellow_b" },
    ReplaceSep = { "blue_a", "blue_b" },
    CommandSep = { "red_a", "red_b" },
    Normal = { "black_text", "normal_bg1" },
    Insert = { "black_text", "green_a" },
    Visual = { "black_text", "yellow_a" },
    Replace = { "black_text", "blue_a" },
    Command = { "black_text", "red_a" },
}

local Highlight_B = {
    NormalSep = { "normal_bg2", "normal_bg3" },
    InsertSep = { "green_b", "green_c" },
    VisualSep = { "yellow_b", "yellow_c" },
    ReplaceSep = { "blue_b", "blue_c" },
    CommandSep = { "red_b", "red_c" },
    Normal = { "white_text", "normal_bg2" },
    Insert = { "white_text", "green_b" },
    Visual = { "white_text", "yellow_b" },
    Replace = { "white_text", "blue_b" },
    Command = { "white_text", "red_b" },
}

airline_colors.c = {
    NormalSep = { "normal_bg3", "NormalBg" },
    InsertSep = { "green_c", "NormalBg" },
    VisualSep = { "yellow_c", "NormalBg" },
    ReplaceSep = { "blue_c", "NormalBg" },
    CommandSep = { "red_c", "NormalBg" },
    Normal = { "white_text", "normal_bg3" },
    Insert = { "white_text", "green_c" },
    Visual = { "white_text", "yellow_c" },
    Replace = { "white_text", "blue_c" },
    Command = { "white_text", "red_c" },
}

local WIDTH_BREAKPOINT = 80

local DividerComponent = { "%=", HIGHLIGHTS.Normal }

local OS_UNAME = uv.os_uname()

local function GetOsIcon()
    local uname = OS_UNAME.sysname
    if uname == "Darwin" then
        return ""
    elseif uname == "Linux" then
        if
            type(OS_UNAME.release) == "string" and OS_UNAME.release:find("arch")
        then
            return ""
        end
        return ""
    elseif uname == "Windows" then
        return ""
    else
        return "󱚟"
    end
end

local Mode = {
    hl_colors = Highlight_A,
    text = function(_, _, width)
        local os_icon = GetOsIcon()
        if width > WIDTH_BREAKPOINT then
            return {
                {
                    " " .. os_icon .. " " .. GetModeName() .. " ",
                    GetHl(),
                },
                { RIGHT_SEP, GetHl(true) },
            }
        end
        return {
            {
                " " .. os_icon .. " " .. GetModeName():sub(1, 1) .. " ",
                GetHl(),
            },
            { RIGHT_SEP, GetHl(true) },
        }
    end,
}

local GitBranch = {
    hl_colors = Highlight_B,
    text = function(bufnr, _, width)
        if width > WIDTH_BREAKPOINT then
            local has_git_branch = vim.fn.exists("*gitbranch#name") > 0
            if has_git_branch then
                local git_branch = vim.fn["gitbranch#name"]()
                if strings.not_empty(git_branch) then
                    return {
                        { "  " .. git_branch, GetHl() },
                        { " ", "" },
                        { RIGHT_SEP, GetHl(true) },
                    }
                end
            end
        end
        return { { RIGHT_SEP, GetHl(true) } }
    end,
}

basic.section_b = {
    hl_colors = Highlight_B,
    text = function(bufnr, _, width)
        if width > WIDTH_BREAKPOINT and git_comps.is_git(bufnr) then
            return {
                { git_comps.git_branch(), state.mode[2] },
                { " ", "" },
                { sep.right_filled, state.mode[2] .. "Sep" },
            }
        end
        return { { sep.right_filled, state.mode[2] .. "Sep" } }
    end,
}

basic.section_c = {
    hl_colors = airline_colors.c,
    text = function()
        return {
            { " ", state.mode[2] },
            { b_components.cache_file_name("[No Name]", "unique") },
            { " " },
            { sep.right_filled, state.mode[2] .. "Sep" },
        }
    end,
}

basic.section_x = {
    hl_colors = airline_colors.c,
    text = function(_, _, width)
        if width > WIDTH_BREAKPOINT then
            return {
                { sep.left_filled, state.mode[2] .. "Sep" },
                { " ", state.mode[2] },
                { b_components.file_encoding() },
                { " " },
                { b_components.file_format({ icon = true }) },
                { " " },
            }
        end
        return {
            { sep.left_filled, state.mode[2] .. "Sep" },
        }
    end,
}

basic.section_y = {
    hl_colors = Highlight_B,
    text = function(_, _, width)
        if width > WIDTH_BREAKPOINT then
            return {
                { sep.left_filled, state.mode[2] .. "Sep" },
                {
                    b_components.cache_file_type({ icon = true }),
                    state.mode[2],
                },
                { " " },
            }
        end
        return { { sep.left_filled, state.mode[2] .. "Sep" } }
    end,
}

basic.section_z = {
    hl_colors = Highlight_A,
    text = function(_, _, width)
        if width > WIDTH_BREAKPOINT then
            return {
                { sep.left_filled, state.mode[2] .. "Sep" },
                { "", state.mode[2] },
                { b_components.progress_lua },
                { " " },
                { b_components.line_col_lua },
            }
        end
        return {
            { sep.left_filled, state.mode[2] .. "Sep" },
            { " ", state.mode[2] },
            { b_components.line_col_lua, state.mode[2] },
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
                        format = "  %s",
                        show_zero = true,
                    }),
                    "red",
                },
                {
                    lsp_comps.lsp_warning({
                        format = "  %s",
                        show_zero = true,
                    }),
                    "yellow",
                },
                {
                    lsp_comps.lsp_hint({ format = "  %s", show_zero = true }),
                    "blue",
                },
            }
        end
        return { " ", "red" }
    end,
}

basic.git = {
    name = "git",
    width = WIDTH_BREAKPOINT,
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
        { "🚦 Quickfix ", { "white_text", "black_text" } },
        { helper.separators.slant_right, { "black_text", "black_light" } },
        {
            function()
                return vim.fn.getqflist({ title = 0 }).title
            end,
            { "cyan", "black_light" },
        },
        { " Total : %L ", { "cyan", "black_light" } },
        { helper.separators.slant_right, { "black_light", "InactiveBg" } },
        { " ", { "InactiveFg", "InactiveBg" } },
        DividerComponent,
        { helper.separators.slant_right, { "InactiveBg", "black_text" } },
        { "🧛 ", { "white_text", "black_text" } },
    },
    always_active = true,
    show_last_status = true,
}

local default = {
    filetypes = { "default" },
    active = {
        Mode,
        GitBranch,
        basic.section_c,
        basic.lsp_diagnos,
        { vim_components.search_count(), { "cyan", "NormalBg" } },
        DividerComponent,
        basic.git,
        basic.section_x,
        basic.section_y,
        basic.section_z,
    },
    inactive = {},
}

-- Turns #rrggbb -> { red, green, blue }
local function rgb_str2num(rgb_color_str)
    if rgb_color_str:find("#") == 1 then
        rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
    end
    local red = tonumber(rgb_color_str:sub(1, 2), 16)
    local green = tonumber(rgb_color_str:sub(3, 4), 16)
    local blue = tonumber(rgb_color_str:sub(5, 6), 16)
    return { red = red, green = green, blue = blue }
end

-- Turns { red, green, blue } -> #rrggbb
local function rgb_num2str(rgb_color_num)
    local rgb_color_str = string.format(
        "#%02x%02x%02x",
        rgb_color_num.red,
        rgb_color_num.green,
        rgb_color_num.blue
    )
    return rgb_color_str
end

local function get_color_brightness(rgb_color)
    local color = rgb_str2num(rgb_color)
    local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
    return brightness / 256
end

-- Clamps the val between left and right
local function clamp(val, left, right)
    if val > right then
        return right
    end
    if val < left then
        return left
    end
    return val
end

-- Changes brightness of rgb_color by percentage
local function brightness_modifier(rgb_color, percentage)
    local color = rgb_str2num(rgb_color)
    color.red = clamp(color.red + (color.red * percentage / 100), 0, 255)
    color.green = clamp(color.green + (color.green * percentage / 100), 0, 255)
    color.blue = clamp(color.blue + (color.blue * percentage / 100), 0, 255)
    return rgb_num2str(color)
end

windline.setup({
    colors_name = function(colors)
        local mod = function(c, value)
            if vim.o.background == "light" then
                return HSL.rgb_to_hsl(c):tint(value):to_rgb()
            end
            return HSL.rgb_to_hsl(c):shade(value):to_rgb()
        end

        colors.normal_bg = colors_hl.get_color_with_fallback(
            { "PmenuSel", "PmenuThumb", "TabLineSel" },
            "bg",
            colors.magenta
        )
        colors.insert_bg = colors_hl.get_color_with_fallback(
            { "String", "MoreMsg" },
            "fg",
            colors.green
        )
        colors.replace_bg = colors_hl.get_color_with_fallback(
            { "Number", "Type" },
            "fg",
            colors.blue
        )
        colors.visual_bg = colors_hl.get_color_with_fallback(
            { "Special", "Boolean", "Constant" },
            "fg",
            colors.yellow
        )
        colors.command_bg = colors_hl.get_color_with_fallback(
            { "Identifier" },
            "fg",
            colors.red
        )

        local contrast_threshold = 0.3
        local brightness_modifier_parameter = 10

        local normal = colors_hl.get_color_with_fallback({ "Normal" }, "bg")
        if normal then
            if get_color_brightness(normal) > 0.5 then
                brightness_modifier_parameter = -brightness_modifier_parameter
            end

            colors.normal_bg = brightness_modifier(
                colors.normal_bg,
                brightness_modifier_parameter
            )
            colors.insert_bg = brightness_modifier(
                colors.insert_bg,
                brightness_modifier_parameter
            )
            colors.replace_bg = brightness_modifier(
                colors.replace_bg,
                brightness_modifier_parameter
            )
            colors.visual_bg = brightness_modifier(
                colors.visual_bg,
                brightness_modifier_parameter
            )
            colors.command_bg = brightness_modifier(
                colors.command_bg,
                brightness_modifier_parameter
            )
        end

        colors.statusline_bg = colors_hl.get_color_with_fallback(
            { "StatusLine", "Normal" },
            "bg",
            "#000000"
        )

        colors.black_text =
            colors_hl.get_color_with_fallback({ "Normal" }, "bg", "#000000")
        colors.white_text =
            colors_hl.get_color_with_fallback({ "Normal" }, "fg", "#ffffff")

        colors.normal_bg1 = colors.normal_bg
        colors.normal_bg2 = mod(colors.normal_bg, 0.5)
        colors.normal_bg3 = mod(colors.normal_bg, 0.7)
        colors.normal_bg4 = colors.statusline_bg

        colors.magenta_a = colors.magenta
        colors.magenta_b = mod(colors.magenta, 0.5)
        colors.magenta_c = mod(colors.magenta, 0.7)

        colors.yellow_a = colors.yellow
        colors.yellow_b = mod(colors.yellow, 0.5)
        colors.yellow_c = mod(colors.yellow, 0.7)

        colors.blue_a = colors.blue
        colors.blue_b = mod(colors.blue, 0.5)
        colors.blue_c = mod(colors.blue, 0.7)

        colors.green_a = colors.green
        colors.green_b = mod(colors.green, 0.5)
        colors.green_c = mod(colors.green, 0.7)

        colors.red_a = colors.red
        colors.red_b = mod(colors.red, 0.5)
        colors.red_c = mod(colors.red, 0.7)

        return colors
    end,
    statuslines = {
        default,
        quickfix,
    },
})
