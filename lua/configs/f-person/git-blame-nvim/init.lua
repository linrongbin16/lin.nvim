-- disable git blame on start
vim.g.gitblame_enabled = 0
-- delay
vim.g.gitblame_delay = 300
-- message template
vim.g.gitblame_message_template = "  <author> • <date> • <summary>"
vim.g.gitblame_message_when_not_committed =
    "  <author> • <date> • Not Committed Yet"