local neo_tree = {}

--- @return string | nil path
function neo_tree.get_cur_path()
	local manager = require("neo-tree.sources.manager")
	local ok, state = pcall(manager.get_state, "filesystem")
	if not ok then
		return nil
	end

	local node = state.tree:get_node()
	local path = node:get_id()
	return path
end

function neo_tree.refresh()
	vim.cmd("Neotree refresh")
end

return neo_tree
