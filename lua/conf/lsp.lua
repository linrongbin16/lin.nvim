local constants = require("conf/constants")

-- key mappings
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function()
		local bufmap = function(mode, lhs, rhs)
			local opts = { buffer = true, noremap = true, silent = true }
			vim.keymap.set(mode, lhs, rhs, opts)
		end
		bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
		bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
		bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
		bufmap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
		bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
		bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
		bufmap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
		-- if vim.fn.exists(":Lspsaga") ~= 0 then
		-- 	bufmap("n", "<Leader>rn", "<cmd>Lspsaga rename<CR>")
		-- else
			bufmap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
		-- end
		bufmap("n", "<Leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>")
		bufmap("x", "<Leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>")
		-- if vim.fn.exists(":Lspsaga") ~= 0 then
		-- 	bufmap("n", "<Leader>ca", "<cmd>Lspsaga code_action<CR>")
		-- 	bufmap("x", "<Leader>ca", "<cmd>Lspsaga code_action<CR>")
		-- else
			bufmap("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
			bufmap("x", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")
		-- end
		bufmap("n", "<Leader>df", "<cmd>lua vim.diagnostic.open_float()<cr>")
		bufmap("n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>")
		bufmap("n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>")
		bufmap("n", "<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>")
		bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
		bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
	end,
})

-- diagnostic
local diagnostics_sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = "",
	})
end

diagnostics_sign({ name = "DiagnosticSignError", text = constants.lsp.diagnostics.signs["error"] })
diagnostics_sign({ name = "DiagnosticSignWarn", text = constants.lsp.diagnostics.signs["warning"] })
diagnostics_sign({ name = "DiagnosticSignInfo", text = constants.lsp.diagnostics.signs["info"] })
diagnostics_sign({ name = "DiagnosticSignHint", text = constants.lsp.diagnostics.signs["hint"] })

vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	float = {
		border = constants.ui.border,
		source = "always",
		header = "",
		prefix = "",
	},
})

-- hover/signatureHelp
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = constants.ui.border })
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { border = constants.ui.border })
