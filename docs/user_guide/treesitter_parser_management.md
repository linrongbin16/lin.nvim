# Treesitter Parser Management

This distro uses [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to improve highlightings and syntax.

?> Edit the plugin settings in [lua/configs/nvim-treesitter/nvim-treesitter](https://github.com/linrongbin16/lin.nvim/tree/main/lua/configs/nvim-treesitter/nvim-treesitter) directory.

## Ensure Installed

The nvim-treesitter plugin is configured with option `auto_install = true`, so parsers will be automatically installed when opening the corresponding files. With the `:TSInstall` command, it usually satisfies most use cases.

But in case you want to ensure some parsers installed, please add the `lua/configs/nvim-treesitter/nvim-treesitter/ensure_installed.lua` file that returns a list of tree-sitter parser names. You can simply copy and rename the sample file [lua/configs/nvim-treesitter/nvim-treesitter/ensure_installed_sample.lua](nvim-treesitter/nvim-treesitter/ensure_installed_sample.lua) to enable it, it already has several parsers, which may suit your needs.

?> Check out [lua/configs/nvim-treesitter/nvim-treesitter/config.lua](https://github.com/linrongbin16/lin.nvim/blob/d910b5e4209ebf414aefde5174f944ad5e18c82e/lua/configs/nvim-treesitter/nvim-treesitter/config.lua?plain=1) for how nvim-treesitter loading the ensure installed parsers list.
