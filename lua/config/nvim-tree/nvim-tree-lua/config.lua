vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local constants = require("builtin.utils.constants")

-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
local on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    -- Default key mappings
    api.config.mappings.default_on_attach(bufnr)

    local opts = function(desc)
        return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
        }
    end

    -- Custom key mappings
    --
    -- l => open
    -- h => close directory
    -- ]d => next diagnostic
    -- [d => prev diagnostic
    vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
    vim.keymap.set(
        "n",
        "h",
        api.node.navigate.parent_close,
        opts("Close Directory")
    )
    vim.keymap.set(
        "n",
        "]d",
        api.node.navigate.diagnostics.next,
        opts("Next Diagnostic")
    )
    vim.keymap.set(
        "n",
        "[d",
        api.node.navigate.diagnostics.prev,
        opts("Prev Diagnostic")
    )
end

local function get_view_width()
    local rate = 0.25
    local min_w = 25
    local max_w = 80
    local editor_w = vim.o.columns
    local tree_w = math.floor(editor_w * rate)
    tree_w = vim.fn.min({ max_w, tree_w })
    tree_w = vim.fn.max({ min_w, tree_w })
    return tree_w
end

require("nvim-tree").setup({
    on_attach = on_attach,
    view = {
        width = get_view_width(),
    },
    renderer = {
        highlight_git = true,
        indent_markers = {
            enable = true,
        },
        icons = {
            webdev_colors = true,
            git_placement = "after",
            modified_placement = "before",
            glyphs = {
                default = "", -- nf-fa-file_text_o \uf0f6
            },
        },
    },
    update_focused_file = {
        enable = true,
    },
    git = {
        enable = true,
        ignore = false,
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = constants.lsp.diagnostics.signs.hint,
            info = constants.lsp.diagnostics.signs.info,
            warning = constants.lsp.diagnostics.signs.warning,
            error = constants.lsp.diagnostics.signs.error,
        },
    },
    modified = {
        enable = true,
    },
})

vim.api.nvim_create_augroup("nvim_tree_augroup", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
    group = "nvim_tree_augroup",
    callback = function(data)
        -- use defer_fn to open async
        local function open_impl()
            -- buffer is a [No Name]
            local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
            -- buffer is a directory
            local directory = vim.fn.isdirectory(data.file) == 1
            if not no_name and not directory then
                return
            end

            -- change to the directory
            if directory then
                vim.cmd.cd(data.file)
            end
            -- open the tree
            require("nvim-tree.api").tree.open()
        end
        vim.defer_fn(open_impl, 0)
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    group = "nvim_tree_augroup",
    pattern = "NvimTree",
    callback = function(data)
        local set_key = require("builtin.utils.keymap").set_key
        set_key(
            "n",
            "<leader>.",
            "<cmd>NvimTreeResize +10<cr>",
            { buffer = true, desc = "Resize explorer bigger" }
        )
        set_key(
            "n",
            "<leader>,",
            "<cmd>NvimTreeResize -10<cr>",
            { buffer = true, desc = "Resize explorer smaller" }
        )
    end,
})