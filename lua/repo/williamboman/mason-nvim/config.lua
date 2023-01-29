local constants = require("conf/constants")

require("mason").setup({
	ui = {
		border = constants.ui.border,
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- setup lsp servers
require("lspservers")
