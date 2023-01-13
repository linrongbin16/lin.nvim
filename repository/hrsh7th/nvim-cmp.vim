lua<<EOF

-- Mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- Key mappings
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
        local bufmap = function(mode, lhs, rhs)
            local opts = {buffer = true}
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
        bufmap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
        bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
        bufmap('n', '<Leader>rs', '<cmd>lua vim.lsp.buf.rename()<cr>')
        bufmap('n', '<Leader>cf', '<cmd>lua vim.lsp.buf.format()<cr>')
        bufmap('x', '<Leader>cf', '<cmd>lua vim.lsp.buf.format()<cr>')
        bufmap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        bufmap('x', '<Leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
        bufmap('n', '<Leader>df', '<cmd>lua vim.diagnostic.open_float()<cr>')
        bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
        bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
    end
})

-- Diagnostic
local DiagnosticSign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

DiagnosticSign({name = 'DiagnosticSignError', text = '✘'})
DiagnosticSign({name = 'DiagnosticSignWarn', text = ''})
DiagnosticSign({name = 'DiagnosticSignHint', text = '⚑'})
DiagnosticSign({name = 'DiagnosticSignInfo', text = ''})

local single_border = 'single'

vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    float = {
        border = single_border,
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- hover/signatureHelp
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = single_border}
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {border = single_border}
)

-- lspconfig
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)
lsp_defaults.capabilities = vim.tbl_extend(
    'keep',
    lsp_defaults.capabilities or {},
    require('lsp-status').capabilities
)

-- nvim-cmp
require('luasnip.loaders.from_vscode').lazy_load()
local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Select}
local keyword2 = 2

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp', keyword_length=keyword2},
        { name = 'luasnip', keyword_length=keyword2},
    }, {
        { name = 'buffer', keyword_length=keyword2},
        { name = 'path', keyword_length=keyword2},
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                luasnip = '⋗',
                buffer = 'Ω',
                path = '',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<Down>'] = cmp.mapping.select_next_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({select=true})
            else
                fallback() -- If you use vim-endwise, this fallback will behave the same as vim-endwise.
            end
        end, {'i', 's'}),
        ['<Tab>'] = cmp.mapping(function(fallback)
            local col = vim.fn.col('.') - 1
            if cmp.visible() then
                cmp.confirm({select=true})
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
            else
                cmp.complete()
            end
        end, {'i', 's'}),
        ['<C-f>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<C-b>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {'i', 's'}),
    }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer', keyword_length=keyword2 }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path', keyword_length=keyword2 }
    }, {
        { name = 'cmdline', keyword_length=keyword2 }
    })
})

EOF

augroup LinNvimCmpAuGroup
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.format{async = true}
augroup END
