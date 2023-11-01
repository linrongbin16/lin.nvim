# Changelog

## [2.2.0](https://github.com/linrongbin16/lin.nvim/compare/v2.1.2...v2.2.0) (2023-11-01)


### Features

* **fzfx.nvim:** map '&lt;space&gt;gs' for FzfxGStatus & other performance improvements ([#344](https://github.com/linrongbin16/lin.nvim/issues/344)) ([9c0b7a5](https://github.com/linrongbin16/lin.nvim/commit/9c0b7a57e942412969241475fdc1179282f2c8e7))


### Bug Fixes

* **conform.nvim:** formatter selections ([#346](https://github.com/linrongbin16/lin.nvim/issues/346)) ([4485e82](https://github.com/linrongbin16/lin.nvim/commit/4485e82d339f0b179b93e9a069baad11a5c93d6c))

## [2.1.2](https://github.com/linrongbin16/lin.nvim/compare/v2.1.1...v2.1.2) (2023-10-30)


### Performance Improvements

* **init:** use init.lua ([#340](https://github.com/linrongbin16/lin.nvim/issues/340)) ([63f80fe](https://github.com/linrongbin16/lin.nvim/commit/63f80fe361170d1265f30e8e86a482c2c013bff5))
* **options:** set vim.opt.hidden=false ([#342](https://github.com/linrongbin16/lin.nvim/issues/342)) ([c2b09f9](https://github.com/linrongbin16/lin.nvim/commit/c2b09f9769c4186757fcf7173e3a9929bafb17ce))

## [2.1.1](https://github.com/linrongbin16/lin.nvim/compare/v2.1.0...v2.1.1) (2023-10-30)


### Bug Fixes

* **fzfx.nvim+bufferline.nvim:** fix FzfxGBranches keys and bufferline version ([#338](https://github.com/linrongbin16/lin.nvim/issues/338)) ([1053e4e](https://github.com/linrongbin16/lin.nvim/commit/1053e4ed793b6934bca0866b795063010abc3aaa))

## [2.1.0](https://github.com/linrongbin16/lin.nvim/compare/v2.0.1...v2.1.0) (2023-10-27)


### Features

* **nvim-spectre:** search and replace solution ([#336](https://github.com/linrongbin16/lin.nvim/issues/336)) ([e8159cf](https://github.com/linrongbin16/lin.nvim/commit/e8159cf6fa23746a3e30dfbe1bc267acc51acb9a))
* **stickybuf.nvim:** stick to non-editable buffer ([#334](https://github.com/linrongbin16/lin.nvim/issues/334)) ([5558286](https://github.com/linrongbin16/lin.nvim/commit/55582869341ac5a2c061419aedd14794e030d5a3))

## [2.0.1](https://github.com/linrongbin16/lin.nvim/compare/v2.0.0...v2.0.1) (2023-10-26)


### Bug Fixes

* **lualine.nvim:** fix gitgutter component NPE ([#330](https://github.com/linrongbin16/lin.nvim/issues/330)) ([dc7e915](https://github.com/linrongbin16/lin.nvim/commit/dc7e915add5753f8bb65de48ca2a9fff119e17ab))
* **plugins:** add vim-gitgutter as lualine dependency ([#332](https://github.com/linrongbin16/lin.nvim/issues/332)) ([74f44be](https://github.com/linrongbin16/lin.nvim/commit/74f44be0b8ca2005ee2c6c25f896e7505ec6a2e9))


### Performance Improvements

* **conform.nvim:** use prettier instead of prettierd ([#328](https://github.com/linrongbin16/lin.nvim/issues/328)) ([b8b2edb](https://github.com/linrongbin16/lin.nvim/commit/b8b2edba56fd8cd3d9da24b3ed5cc110715db8ad))

## [2.0.0](https://github.com/linrongbin16/lin.nvim/compare/v1.1.0...v2.0.0) (2023-10-24)


### ⚠ BREAKING CHANGES

* **install:** drop golang and move lazygit.nvim to user plugins ([#326](https://github.com/linrongbin16/lin.nvim/issues/326))

### Features

* **mason-lspconfig.nvim:** set chirdThirdParty=false for lua ls ([#324](https://github.com/linrongbin16/lin.nvim/issues/324)) ([0196772](https://github.com/linrongbin16/lin.nvim/commit/019677226f75dcd918e3513e0f17adea64df0c01))


### Bug Fixes

* **install:** do not install git if exists ([398cb0d](https://github.com/linrongbin16/lin.nvim/commit/398cb0d40eeb651b28998107aff635ba8175614d))
* **install:** fix legacy installer ([#322](https://github.com/linrongbin16/lin.nvim/issues/322)) ([c601326](https://github.com/linrongbin16/lin.nvim/commit/c6013260c2d779b887e4da81265353ddd9b2a426))


### Performance Improvements

* **install:** drop golang and move lazygit.nvim to user plugins ([#326](https://github.com/linrongbin16/lin.nvim/issues/326)) ([701698b](https://github.com/linrongbin16/lin.nvim/commit/701698bf9037ea50958f2dc8dc2ad312ccf0d2d9))
* **lualine.nvim:** remove deadcode ([#320](https://github.com/linrongbin16/lin.nvim/issues/320)) ([4f06922](https://github.com/linrongbin16/lin.nvim/commit/4f0692281fe9f682a0488f0410ea83c432c07531))

## [1.1.0](https://github.com/linrongbin16/lin.nvim/compare/v1.0.1...v1.1.0) (2023-10-24)


### Features

* **install:** install latest git for apt ([#316](https://github.com/linrongbin16/lin.nvim/issues/316)) ([ba4f045](https://github.com/linrongbin16/lin.nvim/commit/ba4f045b4f69ae2c23b9104e71cc042db2edcfa3))


### Performance Improvements

* **neoconf.nvim:** remove 'neoconf.nvim', optimize 'neodev.nvim' loading ([#318](https://github.com/linrongbin16/lin.nvim/issues/318)) ([fa1854b](https://github.com/linrongbin16/lin.nvim/commit/fa1854b3eef0e2de841e310e95642cd82c7c101e))

## [1.0.1](https://github.com/linrongbin16/lin.nvim/compare/v1.0.0...v1.0.1) (2023-10-23)


### Bug Fixes

* **conform.nvim:** same json formatters for 'jsonc' ([#309](https://github.com/linrongbin16/lin.nvim/issues/309)) ([95269f4](https://github.com/linrongbin16/lin.nvim/commit/95269f41abf509a7e98ceea19368331a97987f9a))
* **fzf:** fzf installer ([#313](https://github.com/linrongbin16/lin.nvim/issues/313)) ([e91f1b1](https://github.com/linrongbin16/lin.nvim/commit/e91f1b12e8e9e0aea8fa96d27e46bac06c429a36))

## [1.0.0](https://github.com/linrongbin16/lin.nvim/compare/v0.5.0...v1.0.0) (2023-10-23)


### ⚠ BREAKING CHANGES

* **lazy.nvim:** remove 'user_plugins' module, rename 'user_plugins_blacklist' to 'plugins_blacklist' ([#304](https://github.com/linrongbin16/lin.nvim/issues/304))

### break

* **lazy.nvim:** remove 'user_plugins' module, rename 'user_plugins_blacklist' to 'plugins_blacklist' ([#304](https://github.com/linrongbin16/lin.nvim/issues/304)) ([160d7b4](https://github.com/linrongbin16/lin.nvim/commit/160d7b4df1c0680865dfafd9931aa6ef5d9c9542))


### Performance Improvements

* **builtin:** rewrite message with vim.api.nvim_echo API ([#306](https://github.com/linrongbin16/lin.nvim/issues/306)) ([a742675](https://github.com/linrongbin16/lin.nvim/commit/a742675ec4f80420bae4f03b0bb1dc66ec66c590))
* **neoconf:** lazy load neodev/SchemaStore, move out of neoconf's dependency ([#302](https://github.com/linrongbin16/lin.nvim/issues/302)) ([3410b41](https://github.com/linrongbin16/lin.nvim/commit/3410b41f74c2aa745b702f20aca7df718b67f862))

## [0.5.0](https://github.com/linrongbin16/lin.nvim/compare/v0.4.2...v0.5.0) (2023-10-21)


### Features

* **fzfx.nvim:** add '&lt;space&gt;cm' for vim commands ([#297](https://github.com/linrongbin16/lin.nvim/issues/297)) ([5984ed0](https://github.com/linrongbin16/lin.nvim/commit/5984ed0cb4d839dd81b9a99d80ea4860f238e0e6))


### Bug Fixes

* **git-blame.nvim:** migrate 'init.lua' to 'config.lua' to enable the options ([#296](https://github.com/linrongbin16/lin.nvim/issues/296)) ([4f101fb](https://github.com/linrongbin16/lin.nvim/commit/4f101fb63cd4ea244f48549641937ab9941c1775))
* **markdown-preview.nvim:** fix build ([#298](https://github.com/linrongbin16/lin.nvim/issues/298)) ([84a01b3](https://github.com/linrongbin16/lin.nvim/commit/84a01b320a9268d795b79de5bc2498eb594a3a45))
* **nvim-treesitter:** install 'ensure_installed.lua' for nvim-treesitter ([#300](https://github.com/linrongbin16/lin.nvim/issues/300)) ([aabc03c](https://github.com/linrongbin16/lin.nvim/commit/aabc03c9164cc617f50dd0878f36e76f0b5e588b))


### Performance Improvements

* **configs:** remove deadcode ([#293](https://github.com/linrongbin16/lin.nvim/issues/293)) ([fdf0cf6](https://github.com/linrongbin16/lin.nvim/commit/fdf0cf672eb257b60428e8790dec1ea3cdc2b98b))

## [0.4.2](https://github.com/linrongbin16/lin.nvim/compare/v0.4.1...v0.4.2) (2023-10-17)


### Bug Fixes

* **user_plugins:** fix comment ([#291](https://github.com/linrongbin16/lin.nvim/issues/291)) ([c9741f2](https://github.com/linrongbin16/lin.nvim/commit/c9741f28e1a8cd7753cc1df8b97b0aac52be2492))


### Performance Improvements

* **plugins:** move 'hop.nvim' to user plugins ([#289](https://github.com/linrongbin16/lin.nvim/issues/289)) ([37491dd](https://github.com/linrongbin16/lin.nvim/commit/37491dd6f914041b7345f19dfdf08af08c2cb3b1))

## [0.4.1](https://github.com/linrongbin16/lin.nvim/compare/v0.4.0...v0.4.1) (2023-10-17)


### Bug Fixes

* **colors:** remove '0.0.x' branch for 'github-nvim-theme' ([980fa5d](https://github.com/linrongbin16/lin.nvim/commit/980fa5d5bea5d4deb0ccd70137eca3ec6d3c8fac))


### Performance Improvements

* **colorschemes:** higher the popular bar to 800 stars ([#282](https://github.com/linrongbin16/lin.nvim/issues/282)) ([565861e](https://github.com/linrongbin16/lin.nvim/commit/565861ef7199853cde0bca5a5c9e8a2174fa1bc2))
* **indent-blankline.nvim:** revert back from 'hlchunk.nvim' to 'indent-blankline.nvim' ([#280](https://github.com/linrongbin16/lin.nvim/issues/280)) ([7547426](https://github.com/linrongbin16/lin.nvim/commit/7547426a0662fdd89f7a09540a34c6a1d245dfb6))
* **plugins:** add 'UIEnter' for lazy event ([#285](https://github.com/linrongbin16/lin.nvim/issues/285)) ([df002b4](https://github.com/linrongbin16/lin.nvim/commit/df002b4461249ae99b51e76161b4728f07a82d39))
* **plugins:** lazy load 'lsp-progress.nvim' ([#287](https://github.com/linrongbin16/lin.nvim/issues/287)) ([cfc0bb4](https://github.com/linrongbin16/lin.nvim/commit/cfc0bb40215dd5e706cf275d56a8120568abf332))

## [0.4.0](https://github.com/linrongbin16/lin.nvim/compare/v0.3.1...v0.4.0) (2023-10-13)


### Features

* **hlchunk.nvim:** migrate from 'indent-blankline.nvim' to 'hlchunk.nvim' ([5699b2e](https://github.com/linrongbin16/lin.nvim/commit/5699b2e0948cfbf11df83f799a00017845ace911))
* **hlchunk.nvim:** migrate from 'indent-blankline.nvim' to 'hlchunk.nvim' ([#278](https://github.com/linrongbin16/lin.nvim/issues/278)) ([1231d27](https://github.com/linrongbin16/lin.nvim/commit/1231d2793b40c4754504f8c30bc4f3002cc95138))


### Bug Fixes

* **markdown-preview.nvim:** discard changes after build ([#274](https://github.com/linrongbin16/lin.nvim/issues/274)) ([dceedf7](https://github.com/linrongbin16/lin.nvim/commit/dceedf78ffb04c782c35796380692e18ede6bc36))

## [0.3.1](https://github.com/linrongbin16/lin.nvim/compare/v0.3.0...v0.3.1) (2023-10-12)


### Bug Fixes

* **conform.nvim:** code format via conform.nvim ([#272](https://github.com/linrongbin16/lin.nvim/issues/272)) ([a0c1848](https://github.com/linrongbin16/lin.nvim/commit/a0c184813400adadc31a08208c23caa30b9649ce))

## [0.3.0](https://github.com/linrongbin16/lin.nvim/compare/v0.2.1...v0.3.0) (2023-10-12)


### Features

* **none-ls.nvim:** migrate diagnostics from nvim-lint to none-ls.nvim ([#270](https://github.com/linrongbin16/lin.nvim/issues/270)) ([a7fa8f0](https://github.com/linrongbin16/lin.nvim/commit/a7fa8f01096345a0ca6433291d28682674955574))

## [0.2.1](https://github.com/linrongbin16/lin.nvim/compare/v0.2.0...v0.2.1) (2023-10-10)


### Performance Improvements

* **LuaSnip:** upgrade to v2.* and disable submodules ([#268](https://github.com/linrongbin16/lin.nvim/issues/268)) ([fdd2cf1](https://github.com/linrongbin16/lin.nvim/commit/fdd2cf1c7c75d32b5fd81bbd3125dac86a816a0d))

## [0.2.0](https://github.com/linrongbin16/lin.nvim/compare/v0.1.1...v0.2.0) (2023-10-09)


### Features

* **flash:** add flash.nvim to user plugins ([e48b468](https://github.com/linrongbin16/lin.nvim/commit/e48b4681bdf6ca12b6a6a4ebda109ec1c342c7cb))
* **fzfx:** add file explorer keys ([#259](https://github.com/linrongbin16/lin.nvim/issues/259)) ([ea52f0b](https://github.com/linrongbin16/lin.nvim/commit/ea52f0b11abb01bf58abc3c10bf48df878f2da1d))
* **fzfx:** move Commands to fzfx ([#245](https://github.com/linrongbin16/lin.nvim/issues/245)) ([772eb59](https://github.com/linrongbin16/lin.nvim/commit/772eb59843512ff1706ec4c44d00f1b2342da07f))
* **fzfx:** search lsp diagnostics ([#255](https://github.com/linrongbin16/lin.nvim/issues/255)) ([468771f](https://github.com/linrongbin16/lin.nvim/commit/468771fb5d7177843e05806f1974611b00cf253a))
* ignore lua_ls third-party check ([#237](https://github.com/linrongbin16/lin.nvim/issues/237)) ([47ad879](https://github.com/linrongbin16/lin.nvim/commit/47ad879b526a61302370958d76c413f197fb8fe5))
* luarocks ([#262](https://github.com/linrongbin16/lin.nvim/issues/262)) ([3b56731](https://github.com/linrongbin16/lin.nvim/commit/3b567314f85f56c3397fcdba382ec53a5bfae953))
* **neo-tree:** folder icons ([#247](https://github.com/linrongbin16/lin.nvim/issues/247)) ([cf22c03](https://github.com/linrongbin16/lin.nvim/commit/cf22c033fc042cbc18322f9771bb54f44c218cc1))
* **none-ls.nvim:** migrate from 'nvim-lint' to 'none-ls.nvim' ([#263](https://github.com/linrongbin16/lin.nvim/issues/263)) ([e9cf316](https://github.com/linrongbin16/lin.nvim/commit/e9cf3162c1266571fe4236c6d34eb6f11b7af2db))
* **nvim-treesitter:** add hooks ([#248](https://github.com/linrongbin16/lin.nvim/issues/248)) ([f77e4a8](https://github.com/linrongbin16/lin.nvim/commit/f77e4a826a7566d853b01dfa593abcf305159997))
* **options:** add options and refactor with annotation ([#220](https://github.com/linrongbin16/lin.nvim/issues/220)) ([813daff](https://github.com/linrongbin16/lin.nvim/commit/813daff3ffe5b9c335c39b1e327621394c673f61))
* **options:** layout scale ([#230](https://github.com/linrongbin16/lin.nvim/issues/230)) ([9d83751](https://github.com/linrongbin16/lin.nvim/commit/9d837516ebc369a56d5e21f4e06af33630660bda))
* please release ci ([#266](https://github.com/linrongbin16/lin.nvim/issues/266)) ([11cb754](https://github.com/linrongbin16/lin.nvim/commit/11cb754c22211f913aa63de7575acf3a36b1f566))
* **plugin:** add trouble.nvim for diagnostics list ([#234](https://github.com/linrongbin16/lin.nvim/issues/234)) ([8522213](https://github.com/linrongbin16/lin.nvim/commit/8522213799923af186cae2ed3f304709cd4fedc5))
* **plugin:** improve error message on loading ([#249](https://github.com/linrongbin16/lin.nvim/issues/249)) ([8b94663](https://github.com/linrongbin16/lin.nvim/commit/8b94663474c06556b7cd8cd545fbb77b1a1e7f89))
* sidebar option ([#239](https://github.com/linrongbin16/lin.nvim/issues/239)) ([fff233b](https://github.com/linrongbin16/lin.nvim/commit/fff233b5998bd35c5affab8e8ceec076028e9d97))


### Bug Fixes

* disable all linters by default ([ddfb1eb](https://github.com/linrongbin16/lin.nvim/commit/ddfb1eb41ad12d8d9809bd29ab56da30d4696582))
* enable netrw ([#243](https://github.com/linrongbin16/lin.nvim/issues/243)) ([927b0a4](https://github.com/linrongbin16/lin.nvim/commit/927b0a41caa626d52d24ac3cc0fd20a7ce272463))
* **fzfx:** set 'nvim' env ([#257](https://github.com/linrongbin16/lin.nvim/issues/257)) ([42869f4](https://github.com/linrongbin16/lin.nvim/commit/42869f40d9aec111db100681e1d77d2dc60ada0c))
* install clang for Windows ([#258](https://github.com/linrongbin16/lin.nvim/issues/258)) ([1647896](https://github.com/linrongbin16/lin.nvim/commit/1647896723bac85bf02f8cd91f5528326af51b8c))
* **install:** golang installer ([def2ea9](https://github.com/linrongbin16/lin.nvim/commit/def2ea98cb32ca6f61079a028d96f391aa8b42b1))
* **install:** refresh font cache ([35c0eae](https://github.com/linrongbin16/lin.nvim/commit/35c0eae577b77a41c989dc84c876af6ecd398379))
* **lspconfig:** disable flow lsp ([#241](https://github.com/linrongbin16/lin.nvim/issues/241)) ([f11e6ec](https://github.com/linrongbin16/lin.nvim/commit/f11e6ecae52b3fc6d7eea9ec6566840770cd269b))
* nvim-tree trash on windows ([#238](https://github.com/linrongbin16/lin.nvim/issues/238)) ([f9f72d9](https://github.com/linrongbin16/lin.nvim/commit/f9f72d9b9f226d216d443e9290c294c39b870bf5))


### Performance Improvements

* fzfx keys ([#254](https://github.com/linrongbin16/lin.nvim/issues/254)) ([2a38c81](https://github.com/linrongbin16/lin.nvim/commit/2a38c813daab88049de97b920c0118de41d7a210))
* **indent-blankline.nvim:** disable scope ([5e90928](https://github.com/linrongbin16/lin.nvim/commit/5e90928ef8cda5f6d930eed2b0d67992be6a7883))
* **install:** install go, lazygit via system installer ([#265](https://github.com/linrongbin16/lin.nvim/issues/265)) ([ea9c357](https://github.com/linrongbin16/lin.nvim/commit/ea9c35763d005f51e6d29708784da3d0741daeff))
* **install:** no download if exist ([508d6b5](https://github.com/linrongbin16/lin.nvim/commit/508d6b594aacb7e69efbfb13776a0d4b2e5ba61c))
* **lsp-progress.nvim:** use pattern for lsp-progress event ([#264](https://github.com/linrongbin16/lin.nvim/issues/264)) ([c916161](https://github.com/linrongbin16/lin.nvim/commit/c91616190ef2f38385379a97573782393ea2f850))
* **lsp:** auto-setup ([#227](https://github.com/linrongbin16/lin.nvim/issues/227)) ([cb17817](https://github.com/linrongbin16/lin.nvim/commit/cb17817237f9586cdcabb95067dcbb8fcb809f5e))
* **lspcofig:** update lazy timing for lspconfig and neoconf ([#226](https://github.com/linrongbin16/lin.nvim/issues/226)) ([657e6b1](https://github.com/linrongbin16/lin.nvim/commit/657e6b1bbab5a01e995c6ba21b18f82c8d249ec0))
* **lsp:** remove 'lsp_setup_helper' ([#229](https://github.com/linrongbin16/lin.nvim/issues/229)) ([2d1ce9a](https://github.com/linrongbin16/lin.nvim/commit/2d1ce9af90d891a1d5294b099bcc2c2ab5ad1c26))
* **neoconf:** promote neoconf.nvim ([#228](https://github.com/linrongbin16/lin.nvim/issues/228)) ([718cfe1](https://github.com/linrongbin16/lin.nvim/commit/718cfe1ae06eb020ff4dd3fdf9eb0f42f2c3de14))
* **nvim-tree:** migrate from neo-tree to nvim-tree ([#222](https://github.com/linrongbin16/lin.nvim/issues/222)) ([d13c0c4](https://github.com/linrongbin16/lin.nvim/commit/d13c0c49c940ddfe9b0402236c2a0492c03d96d6))
* **options:** cmdheight=1 ([#240](https://github.com/linrongbin16/lin.nvim/issues/240)) ([5448f15](https://github.com/linrongbin16/lin.nvim/commit/5448f15c83cba59c8308d202633994c18c2f2a27))
* remove is.vim, add luacheck ([#260](https://github.com/linrongbin16/lin.nvim/issues/260)) ([a6067aa](https://github.com/linrongbin16/lin.nvim/commit/a6067aac56c26bbd9c9b5b164dd64dfcc12bd937))
* **yanky:** move yanky.nvim to user plugins ([#250](https://github.com/linrongbin16/lin.nvim/issues/250)) ([435cd6f](https://github.com/linrongbin16/lin.nvim/commit/435cd6f6247665d0ebe37a0c4794dccd41bb21b9))
