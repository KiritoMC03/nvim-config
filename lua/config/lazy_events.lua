local M = {}

function M.setup()
  local Event = require("lazy.core.handler.event")

  -- Define the actual events that should trigger LazyFile
  M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePost" }

  -- Map LazyFile event to those actual events
  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

return M

