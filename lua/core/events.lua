--#region EventEmitter
--- @class sic.core.EventEmitter
--- @field event string
--- @field autocmd? string
--- @field listeners fun(data: any)[]
local EventEmitter = {}
EventEmitter.__index = EventEmitter

--- Creates a new EventEmitter instance
--- @param event string
--- @param autocmd? string
--- @return sic.core.EventEmitter
function EventEmitter.new(event, autocmd)
  local self = setmetatable({}, EventEmitter)
  self.event = event
  self.autocmd = autocmd
  self.listeners = {}
  return self
end

--- Adds a listener to the event
--- @param callback fun(data: any)
function EventEmitter:on(callback)
  table.insert(self.listeners, callback)
end

--- Removes a listener from the event
--- @param callback fun(data: any)
function EventEmitter:off(callback)
  for i, cb in ipairs(self.listeners) do
    if cb == callback then
      table.remove(self.listeners, i)
      break
    end
  end
end

--- Emits the event with optional data
--- @param data? table
function EventEmitter:emit(data)
  data = data or {}
  data.event = self.event
  for _, callback in ipairs(self.listeners) do
    local ok, err = pcall(callback, data)
    if not ok then
      vim.notify("[SuckItCorp][Events] Callback error in '" .. self.event .. "': " .. err, vim.log.levels.ERROR)
    end
  end

  if self.autocmd then
    vim.schedule(function()
      vim.api.nvim_exec_autocmds('User', {
        pattern = self.autocmd,
        modeline = false,
        data = data,
      })
    end)
  end
end

--#endregion

--- @class sic.core.Events
local events = {
  emitters = {} --- @type table<string, sic.core.EventEmitter>
}

--- Register a global listener
--- @param event string
--- @param callback fun(data: any)
function events.on(event, callback)
  if not events.emitters[event] then
    events.emitters[event] = EventEmitter.new(event)
  end
  events.emitters[event]:on(callback)
end

--- Emit a global event
--- @param event string
--- @param data? any
function events.emit(event, data)
  local emitter = events.emitters[event]
  if emitter then
    emitter:emit(data)
  end
end

--- Create a new standalone emitter
--- @param event string
--- @param autocmd? string
--- @return sic.core.EventEmitter
function events.new_emitter(event, autocmd)
  return EventEmitter.new(event, autocmd)
end

return events
