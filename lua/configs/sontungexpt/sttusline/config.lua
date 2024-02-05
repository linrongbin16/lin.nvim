local colors_hsl = require("commons.colors.hsl")
local colors_hl = require("commons.colors.hl")
local uv = require("commons.uv")

local sttusline_colors = require("sttusline.utils.color")

-- separator style: A \ B \ C ---- X / Y / Z
local LEFT_SLANT = ""
local RIGHT_SLANT = ""
local LEFT_SLANT2 = ""
local RIGHT_SLANT2 = ""

local function StrengthenColorBrightness(rgb, percent)
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

local function rgb_str2num(rgb_color_str)
    if rgb_color_str:find("#") == 1 then
        rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
    end
    local red = tonumber(rgb_color_str:sub(1, 2), 16)
    local green = tonumber(rgb_color_str:sub(3, 4), 16)
    local blue = tonumber(rgb_color_str:sub(5, 6), 16)
    return { red = red, green = green, blue = blue }
end

-- Returns brightness level of color in range 0 to 1
-- arbitrary value it's basically an weighted average
local function get_color_brightness(rgb)
    local color = rgb_str2num(rgb)
    local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
    return brightness / 256
end

local function try_strengthen_color_brightness(rgb, percent)
    percent = percent or 0.2
    if rgb then
        local is_light = get_color_brightness(rgb) < 0.5
        if is_light then
            return StrengthenColorBrightness(rgb, percent)
        end
    end
    return rgb
end

-- NormalBgColor = try_strengthen_color_brightness(NormalBgColor)
-- InsertBgColor = try_strengthen_color_brightness(InsertBgColor)
-- ReplaceBgColor = try_strengthen_color_brightness(ReplaceBgColor)
-- VisualBgColor = try_strengthen_color_brightness(VisualBgColor)
-- CommandBgColor = try_strengthen_color_brightness(CommandBgColor)

local HighlightA = {
    bg = NormalBgColor,
    fg = BlackColor,
}
local HighlightB = {
    bg = StrengthenColorBrightness(NormalBgColor, 0.5),
    fg = BlackColor,
}
local HighlightC = {
    bg = StrengthenColorBrightness(NormalBgColor, 0.7),
    fg = WhiteColor,
}
local HighlightD = {
    bg = StatusLineBgColor,
    fg = WhiteColor,
}

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

-- os name, vi mode
local Mode = {
    name = "mode",
    event = { "ModeChanged", "VimResized" },
    user_event = "VeryLazy",
    colors = HighlightA,
    configs = {
        modes = {
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
        },
        mode_colors = {
            ["STTUSLINE_NORMAL_MODE"] = HighlightA,
            ["STTUSLINE_INSERT_MODE"] = {
                fg = WhiteColor,
                bg = InsertBgColor,
            },
            ["STTUSLINE_VISUAL_MODE"] = {
                fg = WhiteColor,
                bg = VisualBgColor,
            },
            ["STTUSLINE_TERMINAL_MODE"] = {
                fg = WhiteColor,
                bg = CommandBgColor,
            },
            ["STTUSLINE_REPLACE_MODE"] = {
                fg = WhiteColor,
                bg = ReplaceBgColor,
            },
            ["STTUSLINE_SELECT_MODE"] = {
                fg = WhiteColor,
                bg = VisualBgColor,
            },
            ["STTUSLINE_COMMAND_MODE"] = {
                fg = WhiteColor,
                bg = CommandBgColor,
            },
            ["STTUSLINE_CONFIRM_MODE"] = {
                fg = WhiteColor,
                bg = CommandBgColor,
            },
        },
    },
    update = function(configs)
        local mode_code = vim.api.nvim_get_mode().mode
        local mode_name = configs.modes[mode_code][1]
        local mode_color = configs.modes[mode_code][2]
        local os_icon = OsNameIcon()
        if mode_name then
            if vim.o.columns > 70 then
                return {
                    {
                        os_icon .. " " .. FullModeName[mode_name] .. " ",
                        configs.mode_colors[mode_color],
                    },
                    {
                        RIGHT_SLANT,
                        { fg = HighlightA.bg, bg = HighlightB.bg },
                    },
                }
            else
                return {
                    {
                        os_icon .. " " .. AbbrModeName[mode_name] .. " ",
                        configs.mode_colors[mode_color],
                    },
                    {
                        RIGHT_SLANT,
                        { fg = HighlightA.bg, bg = HighlightB.bg },
                    },
                }
            end
        end
        return {
            {
                " " .. os_icon .. " " .. string.upper(mode_code) .. " ",
                HighlightA,
            },
            {
                RIGHT_SLANT,
                { fg = HighlightA.bg, bg = HighlightB.bg },
            },
        }
    end,
}

-- file name, file status(readonly/modified), file size
local FileName = {
    name = "filename",
    event = { "BufEnter", "WinEnter", "TextChangedI", "BufWritePost" },
    user_event = "VeryLazy",
    colors = HighlightB,
    separator = { left = LEFT_SLANT },
    padding = { left = 1, right = 0 },
    update = function()
        local filename = vim.fn.expand("%:t")
        if type(filename) ~= "string" or string.len(filename) == 0 then
            return { " " }
        end

        local has_devicons, devicons = pcall(require, "nvim-web-devicons")
        local icon, color_icon
        if has_devicons then
            icon, color_icon =
                devicons.get_icon_color(filename, vim.fn.expand("%:e"))
        end

        local readonly = not vim.api.nvim_buf_get_option(0, "modifiable")
            or vim.api.nvim_buf_get_option(0, "readonly")
        local modified = vim.api.nvim_buf_get_option(0, "modified")
        if readonly then
            filename = filename .. " []"
        elseif modified then
            filename = filename .. " []"
        end

        return {
            icon and { icon .. " ", { fg = color_icon, bg = HighlightB.bg } }
                or "",
            filename,
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
        return string.format(format, file_size, suffixes[i])
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
