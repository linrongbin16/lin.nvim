local windline = require("windline")
local helper = require("windline.helpers")
local sep = helper.separators
local b_components = require("windline.components.basic")
local vim_components = require("windline.components.vim")
local HSL = require("wlanimation.utils")

local lsp_comps = require("windline.components.lsp")
local git_comps = require("windline.components.git")
local cache_utils = require("windline.cache_utils")

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

local function ModifyColor(c, value)
    if vim.o.background == "light" then
        return HSL.rgb_to_hsl(c):tint(value):to_rgb()
    end
    return HSL.rgb_to_hsl(c):shade(value):to_rgb()
end

local NormalBgColor = colors_hl.get_color_with_fallback(
    { "PmenuSel", "PmenuThumb", "TabLineSel" },
    "bg",
    vim.g.terminal_color_5 -- magenta
)
local InsertBgColor = colors_hl.get_color_with_fallback(
    { "String", "MoreMsg" },
    "fg",
    vim.g.terminal_color_2 -- green
)
local ReplaceBgColor = colors_hl.get_color_with_fallback(
    { "Number", "Type" },
    "fg",
    vim.g.terminal_color_4 -- blue
)
local VisualBgColor = colors_hl.get_color_with_fallback(
    { "Special", "Boolean", "Constant" },
    "fg",
    vim.g.terminal_color_3 -- yellow
)
local CommandBgColor = colors_hl.get_color_with_fallback(
    { "Identifier" },
    "fg",
    vim.g.terminal_color_1 -- red
)
local StatusLineBgColor = colors_hl.get_color_with_fallback(
    { "StatusLine", "Normal" },
    "bg",
    "#000000"
)
local BlackColor =
    colors_hl.get_color_with_fallback({ "Normal" }, "bg", "#000000")
local WhiteColor =
    colors_hl.get_color_with_fallback({ "Normal" }, "fg", "#ffffff")

local DiffAddColor = colors_hl.get_color_with_fallback(
    { "GitSignsAdd", "GitGutterAdd", "diffAdded", "DiffAdd" },
    "fg",
    "#008000"
)
local DiffChangeColor = colors_hl.get_color_with_fallback(
    { "GitSignsChange", "GitGutterChange", "diffChanged", "DiffChange" },
    "fg",
    "#FFFF00"
)
local DiffDeleteColor = colors_hl.get_color_with_fallback(
    { "GitSignsDelete", "GitGutterDelete", "diffRemoved", "DiffDelete" },
    "fg",
    "#FF0000"
)

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

local contrast_threshold = 0.3
local brightness_modifier_parameter = 10

local normal = colors_hl.get_color_with_fallback({ "Normal" }, "bg")
if normal then
    if get_color_brightness(normal) > 0.5 then
        brightness_modifier_parameter = -brightness_modifier_parameter
    end

    NormalBgColor =
        brightness_modifier(NormalBgColor, brightness_modifier_parameter)
    InsertBgColor =
        brightness_modifier(InsertBgColor, brightness_modifier_parameter)
    ReplaceBgColor =
        brightness_modifier(ReplaceBgColor, brightness_modifier_parameter)
    VisualBgColor =
        brightness_modifier(VisualBgColor, brightness_modifier_parameter)
    CommandBgColor =
        brightness_modifier(CommandBgColor, brightness_modifier_parameter)
    StatusLineBgColor =
        brightness_modifier(StatusLineBgColor, brightness_modifier_parameter)
end

local NormalBgColor1 = NormalBgColor
local NormalBgColor2 = ModifyColor(NormalBgColor1, 0.5)
local NormalBgColor3 = ModifyColor(NormalBgColor1, 0.7)
local InsertBgColor1 = InsertBgColor
-- local InsertBgColor2 = ModifyColor(InsertBgColor1, 0.5)
-- local InsertBgColor3 = ModifyColor(InsertBgColor1, 0.7)
local VisualBgColor1 = VisualBgColor
-- local VisualBgColor2 = ModifyColor(VisualBgColor1, 0.5)
-- local VisualBgColor3 = ModifyColor(VisualBgColor1, 0.7)
local ReplaceBgColor1 = ReplaceBgColor
-- local ReplaceBgColor2 = ModifyColor(ReplaceBgColor1, 0.5)
-- local ReplaceBgColor3 = ModifyColor(ReplaceBgColor1, 0.7)
local CommandBgColor1 = CommandBgColor
-- local CommandBgColor2 = ModifyColor(CommandBgColor1, 0.5)
-- local CommandBgColor3 = ModifyColor(CommandBgColor1, 0.7)

-- Changes contrast of rgb_color by amount
local function contrast_modifier(rgb_color, amount)
    local color = rgb_str2num(rgb_color)
    color.red = clamp(color.red + amount, 0, 255)
    color.green = clamp(color.green + amount, 0, 255)
    color.blue = clamp(color.blue + amount, 0, 255)
    return rgb_num2str(color)
end

-- returns average of colors in range 0 to 1
-- used to determine contrast level
local function get_color_avg(rgb_color)
    local color = rgb_str2num(rgb_color)
    return (color.red + color.green + color.blue) / 3 / 256
end

-- Changes brightness of foreground color to achieve contrast
-- without changing the color
local function apply_contrast(highlight)
    local highlight_bg_avg = get_color_avg(highlight.bg)
    local contrast_threshold_config = clamp(contrast_threshold, 0, 0.5)
    local contrast_change_step = 5
    if highlight_bg_avg > 0.5 then
        contrast_change_step = -contrast_change_step
    end

    -- Don't waste too much time here max 25 iteration should be more than enough
    local iteration_count = 1
    while
        math.abs(get_color_avg(highlight.fg) - highlight_bg_avg)
            < contrast_threshold_config
        and iteration_count < 25
    do
        highlight.fg = contrast_modifier(highlight.fg, contrast_change_step)
        iteration_count = iteration_count + 1
    end
end

local Highlight_A = {
    NormalSep = { "normal_bg1", "normal_bg2" },
    InsertSep = { "insert_bg1", "normal_bg2" },
    VisualSep = { "visual_bg1", "normal_bg2" },
    ReplaceSep = { "replace_bg1", "normal_bg2" },
    CommandSep = { "command_bg1", "normal_bg2" },
    Normal = { "black_text", "normal_bg1" },
    Insert = { "black_text", "insert_bg1" },
    Visual = { "black_text", "visual_bg1" },
    Replace = { "black_text", "replace_bg1" },
    Command = { "black_text", "command_bg1" },
}

local Highlight_B = {
    NormalSep = { "normal_bg2", "normal_bg3" },
    Normal = { "white_text", "normal_bg2" },
    Insert = { "white_text", "normal_bg2" },
    Visual = { "white_text", "normal_bg2" },
    Replace = { "white_text", "normal_bg2" },
    Command = { "white_text", "normal_bg2" },
}

local Highlight_C = {
    NormalSep = { "normal_bg3", "statusline_bg" },
    Normal = { "white_text", "normal_bg3" },
}

local Highlight_D = {
    NormalSep = { "statusline_bg", "black_text" },
    Normal = { "white_text", "statusline_bg" },
    GitAdd = { "diff_add", "statusline_bg" },
    GitDelete = { "diff_delete", "statusline_bg" },
    GitChange = { "diff_change", "statusline_bg" },
}

local Highlight1_Builder = {
    NormalSep = { fg = NormalBgColor1, bg = NormalBgColor2 },
    InsertSep = { fg = InsertBgColor1, bg = NormalBgColor2 },
    VisualSep = { fg = VisualBgColor1, bg = NormalBgColor2 },
    ReplaceSep = { fg = ReplaceBgColor1, bg = NormalBgColor2 },
    CommandSep = { fg = CommandBgColor1, bg = NormalBgColor2 },
    Normal = { fg = BlackColor, bg = NormalBgColor1 },
    Insert = { fg = BlackColor, bg = InsertBgColor1 },
    Visual = { fg = BlackColor, bg = VisualBgColor1 },
    Replace = { fg = BlackColor, bg = ReplaceBgColor1 },
    Command = { fg = BlackColor, bg = CommandBgColor1 },
}

local Highlight2_Builder = {
    NormalSep = { fg = NormalBgColor2, bg = NormalBgColor3 },
    Normal = { fg = WhiteColor, bg = NormalBgColor2 },
    Insert = { fg = WhiteColor, bg = NormalBgColor2 },
    Visual = { fg = WhiteColor, bg = NormalBgColor2 },
    Replace = { fg = WhiteColor, bg = NormalBgColor2 },
    Command = { fg = WhiteColor, bg = NormalBgColor2 },
}

local Highlight3_Builder = {
    NormalSep = { fg = NormalBgColor3, bg = StatusLineBgColor },
    Normal = { fg = WhiteColor, bg = NormalBgColor3 },
}

local Highlight4_Builder = {
    NormalSep = { fg = StatusLineBgColor, bg = BlackColor },
    Normal = { fg = WhiteColor, bg = StatusLineBgColor },
    GitAdd = { fg = DiffAddColor, bg = StatusLineBgColor },
    GitDelete = { fg = DiffDeleteColor, bg = StatusLineBgColor },
    GitChange = { fg = DiffChangeColor, bg = StatusLineBgColor },
}

for _, h in ipairs(Highlight1_Builder) do
    apply_contrast(h)
end
for _, h in ipairs(Highlight2_Builder) do
    apply_contrast(h)
end
for _, h in ipairs(Highlight3_Builder) do
    apply_contrast(h)
end
for _, h in ipairs(Highlight4_Builder) do
    apply_contrast(h)
end

local basic = {}

local WIDTH_BREAKPOINT = 70

local DividerComponent = { "%=", Highlight_D.Normal }

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
                        { " ", GetHl() },
                        { " " .. git_branch .. " ", "Normal" },
                        { RIGHT_SEP, "NormalSep" },
                    }
                end
            end
        end
        return { { " ", GetHl() }, { RIGHT_SEP, "NormalSep" } }
    end,
}

local function GetFileName(bufnr, _, width)
    local default = "[No Name]"
    local filepath = vim.fn.expand("%:p")
    if strings.empty(filepath) then
        return default
    end
    local filename = vim.fn.fnamemodify(filepath, ":t")
    return filename
end

local FileName = {
    hl_colors = Highlight_C,
    text = function()
        return {
            { " ", "Normal" },
            {
                cache_utils.cache_on_buffer(
                    { "BufEnter", "BufNewFile" },
                    "WindLineComponent_FileName",
                    GetFileName
                ),
            },
            { " " },
        }
    end,
}

local function GetFileStatus(bufnr, _, width)
    local filepath = vim.fn.expand("%:p")
    if strings.empty(filepath) then
        return ""
    end

    local filestatus = ""
    local readonly = not vim.api.nvim_buf_get_option(bufnr, "modifiable")
        or vim.api.nvim_buf_get_option(bufnr, "readonly")
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    if readonly then
        filestatus = "[]"
    elseif modified then
        filestatus = "[]"
    end

    local fsize = vim.fn.getfsize(filepath)
    if fsize <= 0 then
        return filestatus
    end
    local suffixes = { "b", "k", "m", "g" }
    local i = 1
    while fsize > 1024 and i < #suffixes do
        fsize = fsize / 1024
        i = i + 1
    end

    local filesize_format = i == 1 and "[%d%s]" or "[%.1f%s]"
    local filesize = string.format(filesize_format, fsize, suffixes[i])
    if string.len(filestatus) > 0 then
        return filestatus .. " " .. filesize
    else
        return filesize
    end
end

local FileStatus = {
    hl_colors = Highlight_C,
    width = WIDTH_BREAKPOINT,
    text = function()
        return {
            {
                cache_utils.cache_on_buffer({
                    "BufEnter",
                    "WinEnter",
                    "TextChangedI",
                    "BufWritePost",
                }, "WindLineComponent_FileStatus", GetFileStatus),
            },
            { " " },
            { RIGHT_SEP, "NormalSep" },
        }
    end,
}

local function GetGitDiff()
    if vim.fn.exists("*GitGutterGetHunkSummary") > 0 then
        local summary = vim.fn["GitGutterGetHunkSummary"]()
        local signs = { "+", "~", "-" }
        local hls = { "GitAdd", "GitChange", "GitDelete" }
        local components = { { " ", "Normal" } }
        local found = false
        for i = 1, 3 do
            local value = summary[i] or 0
            if value > 0 then
                table.insert(
                    components,
                    { string.format("%s%d ", signs[i], value), hls[i] }
                )
                found = true
            end
        end
        if found then
            return components
        end
    end
    return { { " ", "Normal" } }
end

local GitDiff = {
    width = WIDTH_BREAKPOINT,
    hl_colors = Highlight_D,
    text = cache_utils.cache_on_buffer(
        { "User GitGutter" },
        "WindLineComponent_GitDiff",
        GetGitDiff
    ),
}

basic.section_c = {
    hl_colors = Highlight_C,
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
    hl_colors = Highlight_C,
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
        FileName,
        FileStatus,
        GitDiff,
        { vim_components.search_count(), { "cyan", "NormalBg" } },
        DividerComponent,
        basic.lsp_diagnos,
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
        colors.statusline_bg = Highlight4_Builder.Normal.bg
        colors.black_text = Highlight1_Builder.Normal.fg
        colors.white_text = Highlight4_Builder.Normal.fg

        colors.normal_bg1 = Highlight1_Builder.Normal.bg
        colors.normal_bg2 = Highlight2_Builder.Normal.bg
        colors.normal_bg3 = Highlight3_Builder.Normal.bg
        colors.insert_bg1 = Highlight1_Builder.Insert.bg
        colors.replace_bg1 = Highlight1_Builder.Replace.bg
        colors.visual_bg1 = Highlight1_Builder.Visual.bg
        colors.command_bg1 = Highlight1_Builder.Command.bg

        return colors
    end,
    statuslines = {
        default,
        quickfix,
    },
})
