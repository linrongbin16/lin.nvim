local constants = require("builtin.constants")

require("aerial").setup({
  layout = {
    width = constants.layout.sidebar.scale,
  },
  update_events = "TextChanged,InsertLeave,WinEnter,BufEnter,BufNewFile,BufReadPost,BufWinEnter,BufWinLeave,TabEnter,BufWritePost,CmdlineLeave,CmdwinLeave,TermLeave,TermClose,DirChanged,DiffUpdated,FocusGained,FocusLost",
  show_guides = true,
})
