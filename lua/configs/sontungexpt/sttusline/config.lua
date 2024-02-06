local colors_hsl = require("commons.colors.hsl")
local colors_hl = require("commons.colors.hl")
local uv = require("commons.uv")

local sttusline_colors = require("sttusline.utils.color")

-- slant_left = '',
-- slant_left_thin = '',
-- slant_right = '',
-- slant_right_thin = '',
-- slant_left_2 = '',
-- slant_left_2_thin = '',
-- slant_right_2 = '',
-- slant_right_2_thin = '',
--
-- separator style: A \ B \ C ---- X / Y / Z
local LEFT_SLANT = ""
local RIGHT_SLANT = ""

local function ModifyColorBrightness(rgb, percent)
    local h, s, l = colors_hsl.rgb_string_to_hsl(rgb)
    local tmp = colors_hsl.new(h, s, l, rgb)
    return vim.o.background == "light" and tmp:tint(percent):to_rgb()
        or tmp:shade(percent):to_rgb()
end

local NormalBgColor = colors_hl.get_color_with_fallback(
    { "PmenuSel", "PmenuThumb", "TabLineSel" },
    "bg",
    sttusline_colors.blue
)
local InsertBgColor = colors_hl.get_color_with_fallback(
    { "String", "MoreMsg" },
    "fg",
    sttusline_colors.green
)
local ReplaceBgColor = colors_hl.get_color_with_fallback(
    { "Number", "Type" },
    "fg",
    sttusline_colors.red
)
local VisualBgColor = colors_hl.get_color_with_fallback(
    { "Special", "Boolean", "Constant" },
    "fg",
    sttusline_colors.purple
)
local CommandBgColor = colors_hl.get_color_with_fallback(
    { "Identifier" },
    "fg",
    sttusline_colors.yellow
)
local StatusLineBgColor =
    colors_hl.get_color_with_fallback({ "StatusLine", "Normal" }, "bg")
local BlackColor = colors_hl.get_color_with_fallback(
    { "Normal" },
    "bg",
    sttusline_colors.black
)
local WhiteColor = colors_hl.get_color_with_fallback(
    { "Normal" },
    "fg",
    sttusline_colors.white
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

local HighlightA = {
    bg = NormalBgColor,
    fg = WhiteColor,
}
local HighlightB = {
    bg = ModifyColorBrightness(NormalBgColor, 0.5),
    fg = WhiteColor,
}
local HighlightC = {
    bg = ModifyColorBrightness(NormalBgColor, 0.7),
    fg = WhiteColor,
}
local HighlightD = {
    bg = StatusLineBgColor,
    fg = WhiteColor,
}
local NormalHighlight = {
    fg = WhiteColor,
    bg = NormalBgColor,
}
local InsertHighlight = {
    fg = BlackColor,
    bg = InsertBgColor,
}
local VisualHighlight = {
    fg = BlackColor,
    bg = VisualBgColor,
}
local CommandHighlight = {
    fg = BlackColor,
    bg = CommandBgColor,
}
local ReplaceHighlight = {
    fg = BlackColor,
    bg = ReplaceBgColor,
}

apply_contrast(HighlightA)
apply_contrast(HighlightB)
apply_contrast(HighlightC)
apply_contrast(HighlightD)
apply_contrast(NormalHighlight)
apply_contrast(InsertHighlight)
apply_contrast(VisualHighlight)
apply_contrast(CommandHighlight)
apply_contrast(ReplaceHighlight)

local function IsBigScreen()
    return vim.o.columns > 80
end

local FullModeName = {
    NORMAL = "NORMAL",
    O_PENDING = "O-PENDING",
    VISUAL = "VISUAL",
    V_LINE = "V-LINE",
    V_BLOCK = "V-BLOCK",
    SELECT = "SELECT",
    S_LINE = "S-LINE",
    S_BLOCK = "S-BLOCK",
    INSERT = "INSERT",
    REPLACE = "REPLACE",
    V_REPLACE = "V-REPLACE",
    COMMAND = "COMMAND",
    CONFIRM = "CONFIRM",
    EX = "EX",
    MORE = "MORE",
    SHELL = "SHELL",
    TERMINAL = "TERMINAL",
}
local AbbrModeName = {
    NORMAL = "N",
    O_PENDING = "O",
    VISUAL = "V",
    V_LINE = "V",
    V_BLOCK = "V",
    SELECT = "S",
    S_LINE = "S",
    S_BLOCK = "S",
    INSERT = "I",
    REPLACE = "R",
    V_REPLACE = "V",
    COMMAND = "C",
    CONFIRM = "C",
    EX = "E",
    MORE = "M",
    SHELL = "S",
    TERMINAL = "T",
}

local OS_UNAME = uv.os_uname()

local function OsNameIcon()
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

local ViModes = {
    ["n"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
    ["no"] = { "O_PENDING", "STTUSLINE_O_PENDING_MODE" },
    ["nov"] = { "O_PENDING", "STTUSLINE_O_PENDING_MODE" },
    ["noV"] = { "O_PENDING", "STTUSLINE_O_PENDING_MODE" },
    ["noCTRL-V"] = { "O_PENDING", "STTUSLINE_O_PENDING_MODE" },
    ["niI"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
    ["niR"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
    ["niV"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },

    ["nt"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
    ["ntT"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },

    ["v"] = { "VISUAL", "STTUSLINE_VISUAL_MODE" },
    ["vs"] = { "VISUAL", "STTUSLINE_VISUAL_MODE" },
    ["V"] = { "V_LINE", "STTUSLINE_VISUAL_MODE" },
    ["Vs"] = { "V_LINE", "STTUSLINE_VISUAL_MODE" },
    [""] = { "V_BLOCK", "STTUSLINE_VISUAL_MODE" },

    ["s"] = { "SELECT", "STTUSLINE_SELECT_MODE" },
    ["S"] = { "S_LINE", "STTUSLINE_SELECT_MODE" },
    [""] = { "S_BLOCK", "STTUSLINE_SELECT_MODE" },

    ["i"] = { "INSERT", "STTUSLINE_INSERT_MODE" },
    ["ic"] = { "INSERT", "STTUSLINE_INSERT_MODE" },
    ["ix"] = { "INSERT", "STTUSLINE_INSERT_MODE" },

    ["t"] = { "TERMINAL", "STTUSLINE_TERMINAL_MODE" },
    ["!"] = { "SHELL", "STTUSLINE_TERMINAL_MODE" },

    ["R"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
    ["Rc"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
    ["Rx"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
    ["Rv"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
    ["Rvc"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
    ["Rvx"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },

    ["c"] = { "COMMAND", "STTUSLINE_COMMAND_MODE" },
    ["cv"] = { "EX", "STTUSLINE_COMMAND_MODE" },
    ["ce"] = { "EX", "STTUSLINE_COMMAND_MODE" },

    ["r"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
    ["rm"] = { "MORE", "STTUSLINE_CONFIRM_MODE" },
    ["r?"] = { "CONFIRM", "STTUSLINE_CONFIRM_MODE" },
    ["x"] = { "CONFIRM", "STTUSLINE_CONFIRM_MODE" },
}

local ViModeColors = {
    ["STTUSLINE_NORMAL_MODE"] = NormalHighlight,
    ["STTUSLINE_INSERT_MODE"] = InsertHighlight,
    ["STTUSLINE_VISUAL_MODE"] = VisualHighlight,
    ["STTUSLINE_TERMINAL_MODE"] = CommandHighlight,
    ["STTUSLINE_REPLACE_MODE"] = ReplaceHighlight,
    ["STTUSLINE_SELECT_MODE"] = VisualHighlight,
    ["STTUSLINE_COMMAND_MODE"] = CommandHighlight,
    ["STTUSLINE_CONFIRM_MODE"] = CommandHighlight,
}

-- os name, vi mode
local Mode = {
    name = "mode",
    event = { "ModeChanged", "VimResized" },
    user_event = "VeryLazy",
    colors = HighlightA,
    update = function(configs)
        local mode_code = vim.api.nvim_get_mode().mode
        local mode_name = ViModes[mode_code][1]
        local mode_hl = ViModes[mode_code][2]
        local os_icon = OsNameIcon()

        local mode_text_value

        if mode_name then
            if IsBigScreen() then
                mode_text_value = FullModeName[mode_name]
            else
                mode_text_value = AbbrModeName[mode_name]
            end
        else
            mode_text_value = string.upper(mode_code)
        end
        local mode_hl_value = mode_name and ViModeColors[mode_hl] or HighlightA
        local sep_fg_color = mode_name and ViModeColors[mode_hl].bg
            or HighlightA.bg
        local sep_bg_color = HighlightB.bg

        return {
            { os_icon .. " " .. mode_text_value .. " ", mode_hl_value },
            { RIGHT_SLANT, { fg = sep_fg_color, bg = sep_bg_color } },
        }
    end,
}

-- file name, file status(readonly/modified), file size
local FileName = {
    name = "filename",
    event = { "BufEnter", "WinEnter", "TextChangedI", "BufWritePost" },
    user_event = "VeryLazy",
    -- colors = HighlightB,
    -- separator = { left = LEFT_SLANT },
    padding = 0,
    update = function()
        local mode_code = vim.api.nvim_get_mode().mode
        local mode_name = ViModes[mode_code][1]
        local mode_hl = ViModes[mode_code][2]

        local sep_fg_color = HighlightB.bg
        local sep_bg_color = mode_name and ViModeColors[mode_hl].bg
            or HighlightA.bg

        local filename = vim.fn.expand("%:t")
        if type(filename) ~= "string" or string.len(filename) == 0 then
            return { " ", { fg = sep_fg_color, bg = sep_bg_color } }
        end

        -- local has_devicons, devicons = pcall(require, "nvim-web-devicons")
        -- local icon, color_icon
        -- if has_devicons then
        --     icon, color_icon =
        --         devicons.get_icon_color(filename, vim.fn.expand("%:e"))
        -- end

        local readonly = not vim.api.nvim_buf_get_option(0, "modifiable")
            or vim.api.nvim_buf_get_option(0, "readonly")
        local modified = vim.api.nvim_buf_get_option(0, "modified")
        if readonly then
            filename = filename .. " []"
        elseif modified then
            filename = filename .. " []"
        end

        return {
            { " ", { fg = sep_fg_color, bg = sep_bg_color } },
            { filename, { fg = HighlightB.fg, bg = sep_bg_color } },
        }
    end,
}

local FileSize = {
    name = "filesize",
    event = { "BufEnter", "BufWritePost" },
    user_event = "VeryLazy",
    colors = HighlightB,
    separator = { right = RIGHT_SLANT },
    update = function()
        local file_name = vim.api.nvim_buf_get_name(0)
        local file_size = vim.fn.getfsize(file_name)
        if type(file_size) ~= "number" or file_size <= 0 then
            return ""
        end

        local suffixes = { "B", "KB", "MB", "GB" }
        local i = 1
        while file_size > 1024 and i < #suffixes do
            file_size = file_size / 1024
            i = i + 1
        end

        local format = i == 1 and "[%d%s]" or "[%.1f%s]"
        return {
            { string.format(format, file_size, suffixes[i]), HighlightB },
            {
                RIGHT_SLANT,
                { fg = HighlightB.bg, bg = HighlightC.bg },
            },
        }
    end,
}

local Components = {
    Mode,
    FileName,
    FileSize,
    "git-branch",
    "git-diff",
    "%=",
    "diagnostics",
    "lsps-formatters",
    "copilot",
    "copilot-loading",
    "indent",
    "encoding",
    "pos-cursor",
    "pos-cursor-progress",
}

require("sttusline").setup({
    on_attach = function(create_update_group) end,
    -- statusline_color = "StatusLine",
    components = Components,
})
