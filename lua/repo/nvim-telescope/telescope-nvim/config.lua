require("telescope").setup({
    defaults = {
        layout_config = {
            horizontal = {
                height = 0.9,
                width = 0.9,
            },
            vertical = {
                height = 0.9,
                width = 0.9,
            },
        },
        mappings = {
            i = {
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
            },
            n = {
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = "ignore_case",
        },
        live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            mappings = { -- extend mappings
                i = {
                    ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                    ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({
                        postfix = " --iglob ",
                    }),
                },
            },
        },
    },
})

require("telescope").load_extension("fzf")
