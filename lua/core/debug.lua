--- @class sic.core.debug
local debug = {
  tag = "[SIC]"
}

--- Format the log message with level tag
--- @param level_tag string
--- @param msg string
--- @return string
local function format_message(level_tag, msg)
  return string.format("%s %s %s", debug.tag, level_tag, msg)
end

--- Show an info-level message
--- @param msg string
function debug.info(msg)
  vim.notify(format_message("[INFO]", msg), vim.log.levels.INFO)
end

--- Show a warning-level message
--- @param msg string
function debug.warn(msg)
  vim.notify(format_message("[WARN]", msg), vim.log.levels.WARN)
end

--- Show an error-level message
--- @param msg string
function debug.error(msg)
  vim.notify(format_message("[ERROR]", msg), vim.log.levels.ERROR)
end

--- Show a message with a custom log level
--- @param level integer
--- @param msg string
function debug.custom(level, msg)
  vim.notify(format_message("[CUSTOM]", msg), level or vim.log.levels.INFO)
end

--- Dumps object to string (recursively for tables)
--- @param obj table | any
--- @return string str object as string
function debug.dump(obj)
  if type(obj) == 'table' then
    local s = '{ '
    for k, v in pairs(obj) do
      local key = type(k) == 'number' and k or '"' .. k .. '"'
      s = s .. '[' .. key .. '] = ' .. debug.dump(v) .. ', '
    end
    return s .. '} '
  else
    return tostring(obj)
  end
end

return debug
