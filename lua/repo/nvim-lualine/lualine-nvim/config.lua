-- {{
-- LspProgress

local LspProgressSpinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
local LspProgressSpinnerLength = #LspProgressSpinner
local LspProgressUpdateTime = 125
local LspProgressState = {
	handlerRegistered = false,
	lastRedraw = false,
	messages = {},
}

local function LspProgressResetLastRedraw()
	LspProgressState.lastRedraw = false
end

local function LspProgressHandler(err, msg, ctx)
	local client_id = ctx.client_id
	local client = vim.lsp.get_client_by_id(client_id)
	if not client then
		return
	end
	local client_name = client.name

	local value = msg.value
	local token = msg.token

	if value.kind then
		-- register client id if not exist
		if not LspProgressState.messages[client_id] then
			LspProgressState.messages[client_id] = { name = client_id, once_messages = {}, progress_messages = {} }
		end

		if value.kind == "begin" then
			-- force begin messages redraw, so here we reset lastRedraw
			LspProgressState.lastRedraw = false
			LspProgressState.messages[client_id].progress_messages[token] = {
				title = value.title,
				message = value.message,
				percentage = value.percentage,
				spinner_index = 1,
				done = false,
			}
		elseif value.kind == "report" then
			LspProgressState.messages[client_id].progress_messages[token].message = value.message
			LspProgressState.messages[client_id].progress_messages[token].percentage = value.percentage
			LspProgressState.messages[client_id].progress_messages[token].spinner_index = (
				LspProgressState.messages[client_id].progress_messages[token].spinner_index + 1
			)
					% LspProgressSpinnerLength
				+ 1
		elseif value.kind == "end" then
			-- force begin messages redraw, so here we reset lastRedraw
			LspProgressState.lastRedraw = false
			if LspProgressState.messages[client_id].progress_messages[token] == nil then
				vim.cmd("echohl WarningMsg")
				vim.cmd(
					"[lualine.LspProgress] Received `end` message with no corressponding `begin` from client_id:"
						.. client_id
						.. "!"
				)
				vim.cmd("echohl None")
			else
				LspProgressState.messages[client_id].progress_messages[token].message = value.message
				LspProgressState.messages[client_id].progress_messages[token].done = true
				LspProgressState.messages[client_id].progress_messages[token].spinner_index = nil
			end
		end
	else
		-- force once messages redraw, so here we reset lastRedraw
		LspProgressState.lastRedraw = false
		table.insert(LspProgressState.onceMessages, { client_id = client_id, content = value, shown = 0 })
	end

	-- if last redraw in update time threshold, skip this redraw
	if LspProgressState.lastRedraw then
		return
	end

	-- if redraw timeout, trigger lualine redraw, and defer until next time
	require("lualine").refresh()
	LspProgressState.lastRedraw = true
	vim.defer_fn(LspProgressResetLastRedraw, LspProgressUpdateTime)
end

-- setup progress handler
if not LspProgressState.handlerRegistered then
	if vim.lsp.handlers["$/progress"] then
		local old_handler = vim.lsp.handlers["$/progress"]
		vim.lsp.handlers["$/progress"] = function(...)
			old_handler(...)
			LspProgressHandler(...)
		end
	else
		vim.lsp.handlers["$/progress"] = LspProgressHandler
	end
	LspProgressState.handlerRegistered = true
end

local function LspProgress2()
	if #vim.lsp.get_active_clients() <= 0 then
		return ""
	end

	local new_messages = {}
	local remove_progress = {}
	local remove_once = {}
	for client_id, data in pairs(LspProgressState.messages) do
		if not vim.lsp.client_is_stopped(client_id) then
			for token, ctx in pairs(data.progress_messages) do
				table.insert(new_messages, {
					progress_message = true,
					name = data.name,
					title = ctx.title,
					message = ctx.message,
					percentage = ctx.percentage,
					spinner_index = ctx.spinner_index,
				})
				if ctx.done then
					table.insert(remove_progress, { client_id = client_id, token = token })
				end
			end
			for i, once_msg in ipairs(data.once_messages) do
				once_msg.shown = once_msg.shown + 1
				if once_msg.shown > 1 then
					table.insert(remove_once, { client_id = client_id, index = i })
				end
				table.insert(new_messages, { once_message = true, name = data.name, content = once_msg.content })
			end
		end
	end

	for _, item in ipairs(remove_once) do
		table.remove(LspProgressState.messages[item.client_id].once_messages, item.index)
	end
	for _, item in ipairs(remove_progress) do
		LspProgressState.messages[item.client_id].progress_messages[item.token] = nil
	end

	local sign = " [LSP]" -- nf-fa-gear \uf013

	if #new_messages <= 0 then
		return sign
	end
	local buffer = {}
	for i, msg in ipairs(new_messages) do
		local builder = { "[" .. msg.name .. "]" }
		if msg.progress_message then
			if msg.spinner_index then
				table.insert(builder, LspProgressSpinner[msg.spinner_index])
			end
			if msg.title and msg.title ~= "" then
				table.insert(builder, msg.title)
			end
			if msg.message and msg.message ~= "" then
				table.insert(builder, msg.message)
			end
			if msg.percentage then
				table.insert(builder, string.format("(%.0f%%%%)", msg.percentage))
			end
		elseif msg.once_message then
			if msg.content and msg.content ~= "" then
				table.insert(builder, msg.content)
			end
		end
		table.insert(buffer, table.concat(builder, " "))
	end
	return table.concat(buffer, " ┆ ")
end

-- }}

local function GitStatus()
	local branch = vim.b.gitsigns_head
	if branch == nil or branch == "" then
		return ""
	end
	local changes = vim.b.gitsigns_status
	if changes == nil or changes == "" then
		return string.format(" %s", branch)
	else
		return string.format(" %s %s", branch, changes)
	end
end

local function Rtrim(s)
	local n = #s
	while n > 0 and s:find("^%s", n) do
		n = n - 1
	end
	return s:sub(1, n)
end

local function LspProgress()
	if #vim.lsp.buf_get_clients() > 0 then
		return Rtrim(require("lsp-status").status())
	end
	return ""
end

local function CursorLocation()
	return " %3l:%-2v"
end

local function CursorHex()
	return "0x%02B"
end

local function TagsStatus()
	if not vim.fn.exists("*gutentags#statusline") then
		return ""
	end
	local stats = vim.fn["gutentags#statusline"]()
	if stats == nil or stats == "" then
		return ""
	end
	return stats
end

local function SearchStatus()
	if vim.v.hlsearch == 0 then
		return ""
	end
	local lastsearch = vim.fn.getreg("/")
	if not lastsearch or lastsearch == "" then
		return ""
	end
	local searchcount = vim.fn.searchcount({ maxcount = 9999 })
	return lastsearch .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
end

local constants = require("conf/constants")

local config = {
	options = {
		icons_enabled = true,
		-- theme = 'auto',

		-- style-1: A > B > C ---- X < Y < Z
		-- component_separators = {'', ''},
		-- section_separators = {'', ''},

		-- style-2: A \ B \ C ---- X / Y / Z
		component_separators = "",
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "filename" },
		lualine_c = {
			GitStatus,
			{
				"diagnostics",
				symbols = {
					error = constants.lsp.diagnostics.signs["error"] .. " ",
					warn = constants.lsp.diagnostics.signs["warning"] .. " ",
					info = constants.lsp.diagnostics.signs["info"] .. " ",
					hint = constants.lsp.diagnostics.signs["hint"] .. " ",
				},
			},
			LspProgress2,
			TagsStatus,
		},
		lualine_x = {
			SearchStatus,
			CursorHex,
			"filetype",
			{
				"fileformat",
				symbols = {
					unix = " LF", -- e712
					dos = " CRLF", -- e70f
					mac = " CR", -- e711
				},
			},
			"encoding",
		},
		lualine_y = { "progress" },
		lualine_z = { CursorLocation },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
}

require("lualine").setup(config)
