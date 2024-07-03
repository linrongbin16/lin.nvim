# Plugin Management

This distro uses [lazy.nvim](https://github.com/folke/lazy.nvim) as its plugin manager, all plugins are listed in [lua/plugins/init.lua](https://github.com/linrongbin16/lin.nvim/tree/main/lua/plugins/init.lua).

By following lazy's [Plugin Spec](https://lazy.folke.io/spec), all the plugins are specified with several options such as `init`, `config`, `keys`, `cmd`, `event`, etc. Here we need to specifically pay attention to several below options, which wrapped with hook functions:

- `init`: Wrapped with [`lua_init`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L43) (for lua files) or [`vim_init`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L51) (for vim scripts).
- `config`: Wrapped with [`lua_config`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L59) (for lua files) or [`vim_config`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L67) (for vim scripts).
- `keys`: Wrapped with [`lua_keys`](https://github.com/linrongbin16/lin.nvim/blob/fbfc5b23a47a30c89bee86a6ed729077bc72cd0f/lua/builtin/utils/plugin.lua?plain=1#L38).

The hooks are doing several things for us:

- Split configurations into multiple files, every config option is a single lua/vim script file, and been loaded by the hook. All these configuration files are placed in [lua/configs](https://github.com/linrongbin16/lin.nvim/tree/main/lua/configs) directory.
- For each plugin, it has a separated configuration directory, the file path follows the `organization/repository` format. Since lua syntax treats dot `.` as module separator (i.e. file path separator), all dots `.` in GitHub's organization and repository are replaced with dash `-`, for example the plugin `fzfx.nvim` are placed in [lua/configs/linrongbin16/fzfx-nvim](https://github.com/linrongbin16/lin.nvim/tree/main/lua/configs/linrongbin16/fzfx-nvim) directory.
- The default `init`, `config`, `keys` configurations load either lua (`init.lua`, `config.lua`, `keys.lua`) or vim scripts (`init.vim`, `config.vim`, `keys.vim`). While user can replace these defaults with their own scripts with a `user_` prefix, i.e. `user_init.lua`, `user_config.lua`, `user_keys.lua`. The hooks will first try to load config files with `user_` prefix, then fallback to default config files.
