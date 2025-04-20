--- @alias FileTemplate "cs_class"
--- @alias TemplateRemplacementKey "file_name"
--- @alias TemplateReplacements table<TemplateRemplacementKey, string>

local templates = {}

--- @param template FileTemplate
--- @return string content
local function read_template_file(template)
	local lines = vim.fn.readfile(vim.fn.stdpath("config") .. "\\templates\\" .. template)
	return table.concat(lines, "\n")
end

--- @param template FileTemplate
--- @param replacements? TemplateReplacements
--- @return string content
function templates.from_file_template(template, replacements)
	local content = read_template_file(template)
	if replacements ~= nil then
		for key, value in pairs(replacements) do
			content = content:gsub("{{_" .. key .. "_}}", value)
		end
	end
	return content
end

return templates
