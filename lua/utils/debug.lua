local M = {}

--- Dumps object to string (recursively for tables)
--- @param obj table | any
function M.dump(obj)
   if type(obj) == 'table' then
      local s = '{ '
      for k,v in pairs(obj) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(obj)
   end
end

return M
