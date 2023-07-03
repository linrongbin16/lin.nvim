-- ---- LSP Options ----

local constants = require("builtin.utils.constants")
local set_key = require("builtin.utils.keymap").set_key

-- diagnostic signs
local function make_diagnostic_sign(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
    })
end

make_diagnostic_sign({
    name = "DiagnosticSignError",
    text = constants.lsp.diagnostics.signs.error,
})
make_diagnostic_sign({
    name = "DiagnosticSignWarn",
    text = constants.lsp.diagnostics.signs.warning,
})
make_diagnostic_sign({
    name = "DiagnosticSignInfo",
    text = constants.lsp.diagnostics.signs.info,
})
make_diagnostic_sign({
    name = "DiagnosticSignHint",
    text = constants.lsp.diagnostics.signs.hint,
})

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
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = constants.ui.border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = constants.ui.border }
)

local function diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

local function make_desc(value)
    return { buffer = true, desc = value }
end

vim.api.nvim_create_augroup("lsp_attach_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "lsp_attach_augroup",
    callback = function()
        -- lsp key mappings
        -- navigation
        if vim.fn.exists(":Glance") > 0 then
            set_key(
                "n",
                "gd",
                "<CMD>Glance definitions<CR>",
                make_desc("Go to definitions")
            )
            set_key(
                "n",
                "gt",
                "<CMD>Glance type_definitions<CR>",
                make_desc("Go to type definitions")
            )
            set_key(
                "n",
                "gi",
                "<CMD>Glance implementations<CR>",
                make_desc("Go to implementations")
            )
            set_key(
                "n",
                "gr",
                "<CMD>Glance references<CR>",
                make_desc("Go to references")
            )
        else
            set_key(
                "n",
                "gd",
                "<cmd>lua vim.lsp.buf.definition()<cr>",
                make_desc("Go to definitions")
            )
            set_key(
                "n",
                "gt",
                "<cmd>lua vim.lsp.buf.type_definition()<cr>",
                make_desc("Go to type definitions")
            )
            set_key(
                "n",
                "gi",
                "<cmd>lua vim.lsp.buf.implementation()<cr>",
                make_desc("Go to implementations")
            )
            set_key(
                "n",
                "gr",
                "<cmd>lua vim.lsp.buf.references()<cr>",
                make_desc("Go to references")
            )
        end
        set_key(
            "n",
            "gD",
            "<cmd>lua vim.lsp.buf.declaration()<cr>",
            make_desc("Go to declarations")
        )
        set_key(
            "n",
            "<leader>ic",
            "<cmd>lua vim.lsp.buf.incoming_calls()<cr>",
            make_desc("Go to incoming calls")
        )
        set_key(
            "n",
            "<leader>og",
            "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>",
            make_desc("Go to outgoing calls")
        )

        -- hover
        set_key(
            "n",
            "K",
            "<cmd>lua vim.lsp.buf.hover()<cr>",
            make_desc("Show hover")
        )

        set_key(
            { "n", "i" },
            "<C-k>",
            "<cmd>lua vim.lsp.buf.signature_help()<cr>",
            make_desc("Show signature help")
        )

        -- operation
        set_key(
            "n",
            "<Leader>rn",
            "<cmd>lua vim.lsp.buf.rename()<cr>",
            make_desc("Rename symbol")
        )
        set_key(
            { "n", "x" },
            "<Leader>cf",
            "<cmd>lua vim.lsp.buf.format({async=false})<cr>",
            make_desc("Code format")
        )
        set_key(
            "n",
            "<Leader>ca",
            "<cmd>lua vim.lsp.buf.code_action()<cr>",
            make_desc("Code actions")
        )
        set_key(
            "x",
            "<Leader>ca",
            "<cmd>lua vim.lsp.buf.range_code_action()<cr>",
            make_desc("Code actions")
        )

        -- diagnostic
        set_key(
            "n",
            "<Leader>ds",
            "<cmd>lua vim.diagnostic.open_float()<cr>",
            make_desc("Show diagnostic under cursor")
        )
        set_key(
            "n",
            "]d",
            diagnostic_goto(true),
            make_desc("Next diagnostic item")
        )
        set_key(
            "n",
            "[d",
            diagnostic_goto(false),
            make_desc("Previous diagnostic item")
        )
        set_key(
            "n",
            "]e",
            diagnostic_goto(true, "ERROR"),
            make_desc("Next diagnostic error")
        )
        set_key(
            "n",
            "[e",
            diagnostic_goto(false, "ERROR"),
            make_desc("Previous diagnostic error")
        )
        set_key(
            "n",
            "]w",
            diagnostic_goto(true, "WARN"),
            make_desc("Next diagnostic warning")
        )
        set_key(
            "n",
            "[w",
            diagnostic_goto(false, "WARN"),
            make_desc("Previous diagnostic warning")
        )

        -- switch header/source for c/c++
        set_key(
            "n",
            "<leader>sw",
            ":ClangdSwitchSourceHeader<CR>",
            { silent = false, desc = "Switch between c/c++ header and source" }
        )

        -- (silently)detach lsp client when close buffer
        vim.api.nvim_create_autocmd("LspBufDelete", {
            buffer = vim.api.nvim_get_current_buf(),
            callback = function(opts)
                local bufnr = opts.buf
                local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
                for client_id, _ in pairs(clients) do
                    -- quietly without warning
                    vim.cmd(
                        string.format(
                            "silent lua vim.lsp.buf_detach_client(%d,%d)",
                            bufnr,
                            client_id
                        )
                    )
                end
            end,
        })
    end,
})