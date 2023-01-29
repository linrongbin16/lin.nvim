local window_transparency = 0

local function GetConfig()
	-- put UI box in global editor if window is too small
	if vim.api.nvim_win_get_width(0) <= 40 then
		return {
			relative = "editor",
			prefer_width = 60,
		}
	end
end

local constants = require("conf/constants")
local close_mappings = { ["<ESC>"] = "Close", ["<C-[>"] = "Close", ["<C-c>"] = "Close" }

require("dressing").setup({
	input = {
		border = constants.ui.border,
		win_options = {
			winblend = window_transparency,
		},
		mappings = {
			n = close_mappings,
			i = close_mappings,
		},
		get_config = GetConfig,
	},
	select = {
		nui = {
			border = {
				style = constants.ui.border,
			},
		},
		builtin = {
			border = constants.ui.border,
			win_options = {
				winblend = window_transparency,
			},
			mappings = close_mappings,
		},
		get_config = GetConfig,
	},
})
