vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local const = require("cfg.const")

-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
local on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local opts = function(desc)
        return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
        }
    end

    -- Default mappings. Feel free to modify or remove as you wish.
    --
    -- BEGIN_DEFAULT_ON_ATTACH
    vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
    vim.keymap.set(
        "n",
        "<C-e>",
        api.node.open.replace_tree_buffer,
        opts("Open: In Place")
    )
    vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
    vim.keymap.set(
        "n",
        "<C-r>",
        api.fs.rename_sub,
        opts("Rename: Omit Filename")
    )
    vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
    vim.keymap.set(
        "n",
        "<C-v>",
        api.node.open.vertical,
        opts("Open: Vertical Split")
    )
    vim.keymap.set(
        "n",
        "<C-x>",
        api.node.open.horizontal,
        opts("Open: Horizontal Split")
    )
    vim.keymap.set(
        "n",
        "<BS>",
        api.node.navigate.parent_close,
        opts("Close Directory")
    )
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
    vim.keymap.set(
        "n",
        ">",
        api.node.navigate.sibling.next,
        opts("Next Sibling")
    )
    vim.keymap.set(
        "n",
        "<",
        api.node.navigate.sibling.prev,
        opts("Previous Sibling")
    )
    vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
    vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "a", api.fs.create, opts("Create"))
    vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
    vim.keymap.set(
        "n",
        "B",
        api.tree.toggle_no_buffer_filter,
        opts("Toggle No Buffer")
    )
    vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
    vim.keymap.set(
        "n",
        "C",
        api.tree.toggle_git_clean_filter,
        opts("Toggle Git Clean")
    )
    vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
    vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
    vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
    vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
    vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
    vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
    vim.keymap.set(
        "n",
        "]e",
        api.node.navigate.diagnostics.next,
        opts("Next Diagnostic")
    )
    vim.keymap.set(
        "n",
        "[e",
        api.node.navigate.diagnostics.prev,
        opts("Prev Diagnostic")
    )
    vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
    vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
    vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
    vim.keymap.set(
        "n",
        "gy",
        api.fs.copy.absolute_path,
        opts("Copy Absolute Path")
    )
    vim.keymap.set(
        "n",
        "H",
        api.tree.toggle_hidden_filter,
        opts("Toggle Dotfiles")
    )
    vim.keymap.set(
        "n",
        "I",
        api.tree.toggle_gitignore_filter,
        opts("Toggle Git Ignore")
    )
    vim.keymap.set(
        "n",
        "J",
        api.node.navigate.sibling.last,
        opts("Last Sibling")
    )
    vim.keymap.set(
        "n",
        "K",
        api.node.navigate.sibling.first,
        opts("First Sibling")
    )
    vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
    vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
    vim.keymap.set(
        "n",
        "O",
        api.node.open.no_window_picker,
        opts("Open: No Window Picker")
    )
    vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
    vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
    vim.keymap.set("n", "q", api.tree.close, opts("Close"))
    vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
    vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
    vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
    vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
    vim.keymap.set(
        "n",
        "U",
        api.tree.toggle_custom_filter,
        opts("Toggle Hidden")
    )
    vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
    vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
    vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
    vim.keymap.set(
        "n",
        "Y",
        api.fs.copy.relative_path,
        opts("Copy Relative Path")
    )
    vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
    vim.keymap.set(
        "n",
        "<2-RightMouse>",
        api.tree.change_root_to_node,
        opts("CD")
    )
    -- END_DEFAULT_ON_ATTACH

    -- Custom Key Mappings
    -- l => open
    -- h => close directory
    -- ]d => next diagnostic, ]e is removed
    -- [d => prev diagnostic, [e is removed
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

require("nvim-tree").setup({
    on_attach = on_attach,
    view = {
        width = 40,
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