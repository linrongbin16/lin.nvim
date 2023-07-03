local FD = vim.fn.executable("fdfind") > 0 and "fdfind" or "fd"
local BAT = vim.fn.executable("batcat") > 0 and "batcat" or "bat"

-- --color=never --type f --type symlink --follow --ignore-case
local FD_COMMAND = FD .. " -cnever -tf -tl -L -i"
-- --column --line-number --no-heading --color=always --smart-case
local RG_COMMAND = "rg --column -n --no-heading --color=always -S"

local M = {
    FD = FD,
    BAT = BAT,
    FD_COMMAND = FD_COMMAND,
    RG_COMMAND = RG_COMMAND,
}

return M