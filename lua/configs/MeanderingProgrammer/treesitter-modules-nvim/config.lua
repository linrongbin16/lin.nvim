require("treesitter-modules").setup({
  auto_install = true,
  fold = {
    enable = false,
  },
  highlight = {
    enable = true,
    -- setting this to true will run `:h syntax` and tree-sitter at the same time
    -- set this to `true` if you depend on 'syntax' being enabled
    -- using this option may slow down your editor, and duplicate highlights
    -- instead of `true` it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = false,
  },
})
