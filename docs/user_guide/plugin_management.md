# Plugin Management

## Configurations

This distro uses [lazy.nvim](https://github.com/folke/lazy.nvim) as its plugin manager, all plugins are listed in [lua/plugins/init.lua](https://github.com/linrongbin16/lin.nvim/tree/main/lua/plugins/init.lua).

<!-- Screenshots are recorded with 150x40 kitty terminal -->

<img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/81e18da9-d3d8-498a-b76d-7d02cdb90dd7">

By following lazy's [Plugin Spec](https://lazy.folke.io/spec), all the plugins are specified with several options such as `init`, `config`, `keys`, `cmd`, `event`, etc. Here we need to specifically pay attention to several below options, which wrapped with hook functions:

- `init`: Wrapped with [`lua_init`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L43) (for lua files) or [`vim_init`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L51) (for vim scripts).
- `config`: Wrapped with [`lua_config`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L59) (for lua files) or [`vim_config`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L67) (for vim scripts).
- `keys`: Wrapped with [`lua_keys`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L38). Note: `keys` option doesn't support vim scripts.

The hooks are doing several things for us:

- Split configurations into multiple files, every option is a single lua/vim script file, and been loaded by the hook. All these configuration files are placed in [lua/configs](https://github.com/linrongbin16/lin.nvim/tree/main/lua/configs) directory.

  <!-- Screenshots are recorded with 150x40 kitty terminal -->
  <img width="70%" alt="image" src="https://github.com/linrongbin16/lin.nvim/assets/6496887/bb97b89d-26f9-46ea-8402-edbe51ef9492">

- For each plugin, it has a separated configuration directory, the file path follows the `organization/repository` format. Since lua syntax treats dot `.` as module separator (i.e. file path separator), all dots `.` in GitHub's organization and repository are replaced with dash `-`, for example the plugin `fzfx.nvim` are placed in [lua/configs/linrongbin16/fzfx-nvim](https://github.com/linrongbin16/lin.nvim/tree/main/lua/configs/linrongbin16/fzfx-nvim) directory.
- The hooks will by default load either lua (`init.lua`, `config.lua`, `keys.lua`) or vim scripts (`init.vim`, `config.vim`, `keys.vim`). While user can replace these defaults with their own scripts with a `user_` prefix, i.e. `user_init.lua`, `user_config.lua`, `user_keys.lua` and `user_init.vim`, `user_config.vim`. The hooks will first try to load config files with `user_` prefix, then fallback to default config files. For example you can simply copy and rename [lua/configs/SmiteshP/nvim-navic/user_init_sample.lua](https://github.com/linrongbin16/lin.nvim/blob/84e13c1eefc70f756953582fe95306feadd18e66/lua/configs/SmiteshP/nvim-navic/user_init_sample.lua?plain=1) to `user_init.lua` to replace the default `init.lua`.

## Add/Disable Plugins

This distro embedded a set of plugins by default, but a thousand (Neo)vim users will have a thousand (Neo)vim configurations, it allows users to add new and disable embedded.

To add a new plugin, please add a `lua/plugins/users.lua` file that follows the same structure of the `lua/plugins/init.lua`. You can simply copy and rename the sample file [lua/plugins/users_sample.lua](https://github.com/linrongbin16/lin.nvim/tree/main/lua/plugins/users_sample.lua) to enable it, it already has a lot of other recommended plugins, which may suit your needs.

To disable an embedded plugin, please add a `lua/plugins_blacklist.lua` file that contains a set of plugin names formatted in `organization/repository`. You can simply copy and rename the sample file [lua/plugins_blacklist_sample.lua](https://github.com/linrongbin16/lin.nvim/tree/main/lua/plugins_blacklist_sample.lua) to enable it.

?> Check out [lua/configs/folke/lazy-nvim/config.lua](https://github.com/linrongbin16/lin.nvim/blob/d910b5e4209ebf414aefde5174f944ad5e18c82e/lua/configs/folke/lazy-nvim/config.lua?plain=1) for how lazy.nvim loading the plugins list.
