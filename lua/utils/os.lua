local M = {}

function M.is_win()
	return vim.loop.os_uname().version:match("Windows") ~= nil
end

return M
