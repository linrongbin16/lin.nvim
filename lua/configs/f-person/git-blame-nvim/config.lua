require("gitblame").setup({
    enabled = false,
    delay = 500,
    message_template = "  <author> • <date> • <summary>",
    message_when_not_committed = "  <author> • <date> • Not Committed Yet",
})
