-- ---- Plugins Header ----

return {

    -- ---- Infrastructure ----
    'wbthomason/packer.nvim',
    { 'nathom/filetype.nvim', init = function()
        require('repo/nathom/filetype-nvim/init')
    end },
    'lewis6991/impatient.nvim',
    'neovim/nvim-lspconfig',
    'dstein64/vim-startuptime',

    -- ---- Colorscheme ----
    'bluz71/vim-nightfly-colors',
    'bluz71/vim-moonfly-colors',
    { 'catppuccin/nvim', name = 'catppuccin' },
    { 'challenger-deep-theme/vim', name = 'challenger-deep' },
    'cocopon/iceberg.vim',
    'EdenEast/nightfox.nvim',
    { 'embark-theme/vim', name = 'embark' },
    'fenetikm/falcon',
    { 'folke/tokyonight.nvim', branch = 'main' },
    -- inherit 'lifepillar/vim-solarized8'
    'ishan9299/nvim-solarized-lua',
    { 'junegunn/seoul256.vim', init = function()
        vim.cmd('source $HOME/.vim/repo/junegunn/seoul256.vim/init.vim')
    end },
    -- inherit sainnhe/gruvbox-material
    { 'luisiacc/gruvbox-baby', branch = 'main' },
    -- inherit kaicataldo/material.vim
    'marko-cerovac/material.nvim',
    'mhartington/oceanic-next',
    -- inherit dracula/vim
    'Mofiqul/dracula.nvim',
    -- inherit joshdick/onedark.vim, tomasiser/vim-code-dark, olimorris/onedarkpro.nvim
    'navarasu/onedark.nvim',
    'NLKNguyen/papercolor-theme',
    { 'pineapplegiant/spaceduck', branch = 'main' },
    'preservim/vim-colors-pencil',
    'projekt0n/github-nvim-theme',
    'raphamorim/lucario',
    'rebelot/kanagawa.nvim',
    'Rigellute/rigel',
    'romainl/Apprentice',
    { 'rose-pine/neovim', name = 'rose-pine' },
    'sainnhe/edge',
    'sainnhe/everforest',
    -- inherit sickill/vim-monokai
    'sainnhe/sonokai',
    'shaunsingh/nord.nvim',
    'srcery-colors/srcery-vim',

    -- ---- Highlight ----
    { 'RRethy/vim-illuminate', init = function()
        require('repo/RRethy/vim-illuminate/init')
    end, config = function()
        vim.cmd('source $HOME/.vim/repo/RRethy/vim-illuminate/config.vim')
    end },
    { 'NvChad/nvim-colorizer.lua', event = 'VeryLazy', config = function()
        require('repo/NvChad/nvim-colorizer-lua/config')
    end },
    'andymass/vim-matchup',
    { 'inkarkat/vim-mark', dependencies = { 'inkarkat/vim-ingo-library' }, init = function()
        vim.cmd('source $HOME/.vim/repo/inkarkat/vim-mark/init.vim')
    end, config = function()
        vim.cmd('source $HOME/.vim/repo/inkarkat/vim-mark/config.vim')
    end },

    -- ---- UI ----
    -- File explorer
    { 'nvim-neo-tree/neo-tree.nvim', branch = 'v2.x', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' }, config = function()
        require('repo/nvim-neo-tree/neo-tree-nvim/config')
vim.cmd('source $HOME/.vim/repo/nvim-neo-tree/neo-tree.nvim/config.vim')
    end },
    -- Tabline
    { 'akinsho/bufferline.nvim', version = 'v3.*', dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim"} , config = function()
        require('repo/akinsho/bufferline-nvim/config')
vim.cmd('source $HOME/.vim/repo/akinsho/bufferline.nvim/config.vim')
    end },
    -- Indentline
    'lukas-reineke/indent-blankline.nvim',
    -- Statusline
    { 'nvim-lualine/lualine.nvim', dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
        require('repo/nvim-lualine/lualine-nvim/config')
    end },
    { 'nvim-lua/lsp-status.nvim', config = function()
        require('repo/nvim-lua/lsp-status-nvim/config')
    end },
    -- Git
    { 'lewis6991/gitsigns.nvim', config = function()
        require('repo/lewis6991/gitsigns-nvim/config')
vim.cmd('source $HOME/.vim/repo/lewis6991/gitsigns.nvim/config.vim')
    end },
    -- Terminal
    { 'akinsho/toggleterm.nvim', version = '*', config = function()
        require('repo/akinsho/toggleterm-nvim/config')
    end },
    -- UI hooks
    { 'stevearc/dressing.nvim', config = function()
        require('repo/stevearc/dressing-nvim/config')
    end },
    -- Smooth scrolling
    'karb94/neoscroll.nvim',
    -- Structures/Outlines
    'liuchengxu/vista.vim',
    { 'ludovicchabant/vim-gutentags', init = function()
        vim.cmd('source $HOME/.vim/repo/ludovicchabant/vim-gutentags/init.vim')
    end },

    -- ---- Search ----
    { 'junegunn/fzf', build = ':call fzf#install()' },
    { 'junegunn/fzf.vim', init = function()
        vim.cmd('source $HOME/.vim/repo/junegunn/fzf.vim/init.vim')
    end, config = function()
        vim.cmd('source $HOME/.vim/repo/junegunn/fzf.vim/config.vim')
    end },
    { 'ojroques/nvim-lspfuzzy', config = function()
        require('repo/ojroques/nvim-lspfuzzy/config')
    end },

    -- ---- LSP server ----
    { 'williamboman/mason.nvim', config = function()
        require('repo/williamboman/mason-nvim/config')
    end },
    'williamboman/mason-lspconfig.nvim',
    { 'jose-elias-alvarez/null-ls.nvim', dependencies = { "nvim-lua/plenary.nvim" } },
    'jay-babu/mason-null-ls.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    { 'hrsh7th/nvim-cmp', config = function()
        require('repo/hrsh7th/nvim-cmp/config')
vim.cmd('source $HOME/.vim/repo/hrsh7th/nvim-cmp/config.vim')
    end },
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- ---- Language support ----
    -- Markdown
    { 'iamcco/markdown-preview.nvim', build = 'cd app && npm install', init = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { 'markdown' } },
    -- Clangd extension
    'p00f/clangd_extensions.nvim',
    -- Lex/yacc, flex/bison
    { 'justinmk/vim-syntax-extra', ft = { "lex", "flex", "yacc", "bison" } },
    -- LLVM
    { 'rhysd/vim-llvm', ft = { "llvm", "mir", "mlir", "tablegen" }, init = function()
        vim.cmd('source $HOME/.vim/repo/rhysd/vim-llvm/init.vim')
    end },
    -- Hive
    { 'zebradil/hive.vim', ft = { "hive" } },
    -- Slim
    { 'slim-template/vim-slim', ft = { "slim" } },

    -- ---- Movement ----
    -- Cursor Movement
    { 'phaazon/hop.nvim', branch = 'v2', config = function()
        require('repo/phaazon/hop-nvim/config')
vim.cmd('source $HOME/.vim/repo/phaazon/hop.nvim/config.vim')
    end },
    { 'ggandor/leap.nvim', dependencies = { "tpope/vim-repeat" }, config = function()
        require('repo/ggandor/leap-nvim/config')
    end },
    { 'chaoren/vim-wordmotion', init = function()
        vim.cmd('source $HOME/.vim/repo/chaoren/vim-wordmotion/init.vim')
    end, config = function()
        vim.cmd('source $HOME/.vim/repo/chaoren/vim-wordmotion/config.vim')
    end },

    -- ---- Editing enhancement ----
    -- HTML tag
    { 'alvan/vim-closetag', init = function()
        vim.cmd('source $HOME/.vim/repo/alvan/vim-closetag/init.vim')
    end },
    -- Comment
    { 'numToStr/Comment.nvim', config = function()
        require('repo/numToStr/Comment-nvim/config')
    end },
    -- Autopair
    { 'windwp/nvim-autopairs', config = function()
        require('repo/windwp/nvim-autopairs/config')
    end },
    -- Incremental search
    'haya14busa/is.vim',
    -- Other
    'tpope/vim-repeat',
    'mbbill/undotree',
    'editorconfig/editorconfig-vim',
}

-- ---- Plugins Footer ----
