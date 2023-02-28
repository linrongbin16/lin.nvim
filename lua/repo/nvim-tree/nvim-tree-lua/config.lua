local key_mappings = {
    -- navigation
    { key = "l", action = "edit" }, -- open folder or edit file
    { key = "h", action = "close_node" }, -- close folder

    -- diagnostics
    { key = "]d", action = "next_diag_item" }, -- next diagnostic item
    { key = "[d", action = "prev_diag_item" }, -- previous diagnostic item
    { key = "]e", action = "" }, -- removed old next diagnostic item
    { key = "[e", action = "" }, -- removed old previous diagnostic item
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local const = require("cfg.const")

require("nvim-tree").setup({
    -- open_on_setup = true, -- deprecated
    -- open_on_setup_file = true,
    view = {
        width = 40,
        mappings = {
            custom_only = false,
            list = key_mappings,
        },
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
    diagnostics = {
        enable = true,
        icons = {
            hint = const.lsp.diagnostics.signs["hint"],
            info = const.lsp.diagnostics.signs["info"],
            warning = const.lsp.diagnostics.signs["warning"],
            error = const.lsp.diagnostics.signs["error"],
        },
    },
    git = {
        enable = true,
        ignore = false,
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
        local map = require("cfg.keymap").map
        map(
            "n",
            "<leader>.",
            "<cmd>NvimTreeResize +10<cr>",
            { buffer = true, desc = "Resize explorer bigger" }
        )
        map(
            "n",
            "<leader>,",
            "<cmd>NvimTreeResize -10<cr>",
            { buffer = true, desc = "Resize explorer smaller" }
        )
    end,
})
