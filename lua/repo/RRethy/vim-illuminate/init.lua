local const = require("cfg.const")

require("illuminate").configure({
    -- delay: delay in milliseconds
    delay = 500,
    -- disable cursor word for big file
    large_file_cutoff = const.perf.filesystem.maxsize,
})
