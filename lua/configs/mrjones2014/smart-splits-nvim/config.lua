require("smart-splits").setup({
  ignored_buftypes = {
    "nofile",
    "quickfix",
    "prompt",
  },
  -- Ignored filetypes (only while resizing)
  ignored_filetypes = {},

  resize = {
    -- the default number of lines/columns to resize by at a time
    amount = 5,

    -- ignore these autocmd events (via :h eventignore) while processing
    -- smart-splits.nvim computations, which involve visiting different
    -- buffers and windows. These events will be ignored during processing,
    -- and un-ignored on completed. This only applies to resize events,
    -- not cursor movement events.
    ignored_events = {
      "BufEnter",
      "WinEnter",
    },
  },

  move = {
    -- when moving cursor between splits left or right,
    -- place the cursor on the same row of the *screen*
    -- regardless of line numbers. False by default.
    -- Can be overridden via function parameter, see Usage.
    same_row = false,

    -- Desired behavior when your cursor is at an edge and you
    -- are moving towards that same edge:
    -- 'wrap' => Wrap to opposite side
    -- 'split' => Create a new split in the desired direction
    -- 'stop' => Do nothing
    -- function => You handle the behavior yourself
    -- NOTE: If using a function, the function will be called with
    -- a context object with the following fields:
    -- {
    --    mux = {
    --      type:'tmux'|'wezterm'|'kitty'|'zellij'
    --      current_pane_id():number,
    --      is_in_session(): boolean
    --      current_pane_is_zoomed():boolean,
    --      -- following methods return a boolean to indicate success or failure
    --      current_pane_at_edge(direction:'left'|'right'|'up'|'down'):boolean
    --      next_pane(direction:'left'|'right'|'up'|'down'):boolean
    --      resize_pane(direction:'left'|'right'|'up'|'down'):boolean
    --      split_pane(direction:'left'|'right'|'up'|'down',size:number|nil):boolean
    --    },
    --    direction = 'left'|'right'|'up'|'down',
    --    split(), -- utility function to split current Neovim pane in the current direction
    --    wrap(), -- utility function to wrap to opposite Neovim pane
    -- }
    -- NOTE: `at_edge = 'wrap'` is not supported on Kitty terminal
    -- multiplexer, as there is no way to determine layout via the CLI
    at_edge = "wrap",
  },

  swap = {
    -- whether the cursor should follow the buffer when swapping
    -- buffers by default; it can also be controlled by passing
    -- `{ move_cursor = true }` or `{ move_cursor = false }`
    -- when calling the Lua function.
    move_cursor = false,
  },
})
