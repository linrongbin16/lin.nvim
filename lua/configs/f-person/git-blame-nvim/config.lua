require("gitblame").setup({
    enabled = false,
    delay = 300,
    date_format = "%Y/%m/%d %H:%M",
    message_template = "  <author> • <date> • <summary>",
    message_when_not_committed = "  <author> • <date> • Not Committed Yet",
})
