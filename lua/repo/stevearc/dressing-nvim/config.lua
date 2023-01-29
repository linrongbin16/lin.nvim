local window_transparency = 0

local function GetConfig()
	-- put UI box in global editor if window is too small
	if vim.api.nvim_win_get_width(0) < 60 then
		return {
			relative = "editor",
			prefer_width = 80,
		}
	end
end

local constants = require("conf/constants")

require("dressing").setup({
	input = {
		border = constants.ui.border,
		win_options = {
			winblend = window_transparency,
		},
		get_config = GetConfig,
		override = function(conf)
			conf.col = -1
			conf.row = 0
			return conf
		end,
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
		},
		get_config = GetConfig,
	},
})
