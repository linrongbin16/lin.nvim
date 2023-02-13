local constants = require("conf/constants")

require("illuminate").configure({
  -- delay: delay in milliseconds
  delay = 500,
  -- disable cursor word for big file
  large_file_cutoff = constants.perf.filesystem.maxsize,
})
