local ctx_menu = {}

function ctx_menu.show_in_neo_tree()
	ctx_menu.hide_in_neo_tree()
	local config = require("config.ctx_menu.neo_tree")
	local actions = config.get(ctx_menu.hide_in_neo_tree)
	_G.user_state.neo_tree_ctx_menu = require("ctx-menu").show(actions)
end

function ctx_menu.hide_in_neo_tree()
	local current = _G.user_state.neo_tree_ctx_menu
	if current ~= nil then
		require("ctx-menu").close(current)
		_G.user_state.neo_tree_ctx_menu = nil
	end
end

return ctx_menu
