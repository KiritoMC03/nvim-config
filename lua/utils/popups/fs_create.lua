local fs_create = {}

--- @param defult_name? string
--- @param on_submit? function
function fs_create.empty(defult_name, on_submit)
	local Input = require("nui.input")
	local path = require("utils.fn").normalize_to_directory(_G.user_state.last_ctx_menu_path)

	local input = Input({
		position = 0,
		relative = "cursor",
		size = {
			width = 20,
		},
		border = {
			style = "single",
		},
	}, {
		prompt = "> ",
		default_value = defult_name == nil and "file.txt" or defult_name,
		on_submit = function(value)
			local file = path .. "\\" .. value
			local ok, fd = pcall(vim.uv.fs_open, file, "w", 420)
			if not ok then
				vim.notify("Couldn't create file " .. file)
				return
			end
			if on_submit ~= nil then
				on_submit(fd, value)
			end
			vim.uv.fs_close(fd)
			vim.cmd("edit " .. vim.fn.fnameescape(file))
		end,
	})
	input:mount()
end

function fs_create.cs_class()
	local write = function(fd, name)
		--- @type TemplateReplacements
		local replacements = {
			file_name = vim.fn.fnamemodify(name, ":t:r"),
		}
		local content = require("utils.templates").from_file_template("cs_class", replacements)
		vim.uv.fs_write(fd, content)
	end
	fs_create.empty("MyClass.cs", write)
end

return fs_create
