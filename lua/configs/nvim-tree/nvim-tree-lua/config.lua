local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.layout")

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
    -- l => open file/directory
    -- h => close directory
    vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
    vim.keymap.set(
        "n",
        "h",
        api.node.navigate.parent_close,
        opts("Close Directory")
    )

    -- . => cd to folder
    vim.keymap.set("n", ".", api.tree.change_root_to_node, opts("CD"))
    -- <BS> => go to upper folder
    vim.keymap.set("n", "<BS>", api.tree.change_root_to_parent, opts("Up"))

    -- open in new tab/split/vsplit
    vim.keymap.set("n", "<C-w>t", api.node.open.tab, opts("Open: New Tab"))
    vim.keymap.del("n", "<C-t>", { buffer = bufnr })
    vim.keymap.set(
        "n",
        "<C-w>v",
        api.node.open.vertical,
        opts("Open: Vertical Split")
    )
    vim.keymap.del("n", "<C-v>", { buffer = bufnr })
    vim.keymap.set(
        "n",
        "<C-w>s",
        api.node.open.horizontal,
        opts("Open: Horizontal Split")
    )
    vim.keymap.del("n", "<C-x>", { buffer = bufnr })

    -- ]d => next diagnostic
    -- [d => prev diagnostic
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

    -- d => trash
    -- D => delete
    local function trash_put()
        local node = api.tree.get_node_under_cursor()
        local function trash_impl(on_exit, on_stderr)
            local j =
                vim.fn.jobstart("trash" .. ' "' .. node.absolute_path .. '"', {
                    on_exit = on_exit,
                    on_stderr = on_stderr,
                })
            vim.fn.jobwait({ j })
        end

        local err_msg = ""
        local function on_trash_error(_, data)
            if type(data) == "table" then
                err_msg = err_msg .. table.concat(data, " ")
            end
        end
        local function on_trash_exit(_, rc)
            if rc ~= 0 then
                require("nvim-tree.notify").warn(
                    "trash failed: " .. err_msg .. ""
                )
            end
        end

        local prompt_select = "Trash " .. node.name .. " ?"
        local prompt_input = prompt_select .. " y/n: "
        require("nvim-tree.lib").prompt(
            prompt_input,
            prompt_select,
            { "y", "n" },
            { "Yes", "No" },
            function(item_short)
                require("nvim-tree.utils").clear_prompt()
                if item_short == "y" then
                    trash_impl(on_trash_exit, on_trash_error)
                end
            end
        )
    end

    if vim.fn.executable("trash") > 0 then
        vim.keymap.set(
            "n",
            "d",
            constants.os.is_windows and trash_put or api.fs.trash,
            opts("Trash")
        )
    end
    vim.keymap.set("n", "D", api.fs.remove, opts("Delete"))

    -- <C-l> => preview
    vim.keymap.set("n", "<C-l>", api.node.open.preview, opts("Open Preview"))
end

require("nvim-tree").setup({
    on_attach = on_attach,
    view = {
        width = layout.editor.width(
            constants.ui.layout.sidebar.scale,
            constants.ui.layout.sidebar.min,
            constants.ui.layout.sidebar.max
        ),
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
        },
    },
    update_focused_file = {
        enable = true,
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 10000,
    },
    diagnostics = {
        enable = true,
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
        },
        icons = {
            hint = constants.diagnostic.sign.hint,
            info = constants.diagnostic.sign.info,
            warning = constants.diagnostic.sign.warning,
            error = constants.diagnostic.sign.error,
        },
    },
    modified = {
        enable = true,
    },
    trash = {
        cmd = "trash",
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