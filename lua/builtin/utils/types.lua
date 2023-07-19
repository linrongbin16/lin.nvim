-- ---- Types/Annotations ----

--- @alias LuaModule table<string, any>

-- for builtin.utils.layout
--- @alias BuiltinLayoutEditorKey "width"|"height"
--- @alias BuiltinLayoutEditorWidthValue fun(pct:number,min_w:integer,max_w:integer):integer
--- @alias BuiltinLayoutEditorHeightValue fun(pct:number,min_h:integer,max_h:integer):integer
--- @alias BuiltinLayoutEditorValue BuiltinLayoutEditorWidthValue|BuiltinLayoutEditorHeightValue

-- for lazy.nvim spec
--- @alias LazyInitSpec fun():LuaModule
--- @alias LazyConfigSpec fun():LuaModule

-- for vim keymap
-- please checkout:
--   - https://neovim.io/doc/user/lua.html#vim.keymap.set()
--   - https://neovim.io/doc/user/map.html#%3Amap-arguments
--- @alias VimKeymapLhs string
--- @alias VimKeymapRhsFunction fun():nil
--- @alias VimKeymapRhs string|VimKeymapRhsFunction
--- @alias VimKeymapOptsKey "buffer"|"nowait"|"silent"|"script"|"expr"|"noremap"
--- @alias VimKeymapOptsValue boolean
--- @alias VimKeymapOpts table<VimKeymapOptsKey, VimKeymapOptsValue>

--- @alias LazyKeySpec table<any, any>

-- for builtin.utils.keymap
--- @alias BuiltinKeymapSetkey fun(mode:string|string[], lhs:VimKeymapLhs, rhs: VimKeymapRhs, opts: VimKeymapOpts):nil
--- @alias BuiltinKeymapSetlazykey fun(mode:string|string[], lhs:VimKeymapLhs, rhs: VimKeymapRhs, opts: VimKeymapOpts):LazyKeySpec

-- for vim command
--- @alias VimUserCommandOptionKey "args"|"bang"
--- @alias VimUserCommandOptionValue any
--- @alias VimUserCommandOption table<VimUserCommandOptionKey, VimUserCommandOptionValue>

-- for builtin.lsp
--- @alias VimSignOptsKey "name"|"text"
--- @alias VimSignOptsValue string
--- @alias VimSignOpts table<VimSignOptsKey, VimSignOptsValue>