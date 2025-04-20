local ctx_menu = {}

--- @param on_submit function
--- @return CtxMenu.Item[] actions
function ctx_menu.get(on_submit)
	--- @type function
	local wrap = function(fn)
		return function()
			on_submit()
			fn()
		end
	end

	--- @type CtxMenu.Builder
	local builder = require("ctx-menu.builder")
	local fs_create = require("utils.popups.fs_create")
	local add = builder.create_dropdown("Add", {
		builder.create("File", wrap(fs_create.empty)),
		builder.create("Directory"),
		builder.create_dropdown("C#", {
			builder.create("Class", wrap(fs_create.cs_class)),
			builder.create("Interface"),
			builder.create("Struct"),
			builder.create("Enum"),
			builder.create("Mono behaviour"),
			builder.create("Scriptable object"),
		}),
	})
	local git = builder.create_dropdown("Git", {
		builder.create("History"),
	})
	local open_in = builder.create_dropdown("Open in", {
		builder.create("Explorer"),
	})
	return {
		add,
		git,
		open_in,
	}
end

return ctx_menu
