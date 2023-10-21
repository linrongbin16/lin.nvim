-- ---- Colorschemes ----

--- @type string[]
local colornames = {
    "catppuccin",
    "iceberg",
    "dracula",
    "nightfox",
    "gruvbox",
    "tokyonight",
    "zenburn",
    "seoul256",
    "monokai",
    "solarized8",
    "material",
    "OceanicNext",
    "onedark",
    "PaperColor",
    "nord",
    "github_dark",
    "kanagawa",
    "apprentice",
    "rose-pine",
    "everforest",
    "gruvbox-material",
    "sonokai",
    "codedark",
}

math.randomseed(os.clock() * 100000000000)

--- @param option table<any, any>
local function switch_color(option)
    if type(option.args) == "string" and string.len(option.args) > 0 then
        vim.cmd.colorscheme(option.args)
    else
        vim.cmd.colorscheme(colornames[math.random(1, #colornames)])
    end
    if option.bang ~= nil and option.bang then
        if vim.fn.has("diff") > 0 then
            vim.cmd([[ diffupdate ]])
        end
        vim.cmd([[ syntax sync fromstart ]])
    end
end

-- switch to next color
vim.api.nvim_create_user_command("SwitchColor", switch_color, {
    bang = true,
    nargs = "?",
    complete = "color",
    desc = "Switch to next {color}",
})
