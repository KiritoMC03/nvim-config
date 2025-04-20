local functions = {}

--- @param path string
--- @return string
function functions.normalize_to_directory(path)
  if vim.fn.isdirectory(path) == 1 then
    return path
  else
    return vim.fn.fnamemodify(path, ":h")  -- head = parent dir
  end
end

---@param t table
---@return table
function functions.reverseTable(t)
	local reversedTable = {}
	local itemCount = #t
	for k, v in ipairs(t) do
		reversedTable[itemCount + 1 - k] = v
	end
	return reversedTable
end


return functions
