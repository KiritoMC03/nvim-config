local themes = {
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    {
        "navarasu/onedark.nvim",
        name = "onedark",
    },
    {
        "Mofiqul/vscode.nvim",
        name = "vscode",
    },
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
	},
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		name = "oxocarbon",
	},
	{
		"jacoborus/tender.vim",
		name = "tender",
	},
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
	},
	{
		"bluz71/vim-nightfly-colors",
		name = "nightfly",
	},
	{
		"scottmckendry/cyberdream.nvim",
		name = "cyberdream",
	},
	{
		"zenbones-theme/zenbones.nvim",
		name = "zenbones",
	},
	{
		"AlexvZyl/nordic.nvim",
		name = "nordic",
	},
	{
		"savq/melange-nvim",
		name = "melange",
	},
	{
		"rmehri01/onenord.nvim",
		name = "onenord",
	},
	{
		"Shatur/neovim-ayu",
		name = "neovim-ayu",
	},
	{
		"olivercederborg/poimandres.nvim",
		name = "poimandres",
	},
}

for _, theme in ipairs(themes) do
	local storage = require("config.utils.storage")
	local config = storage.load_cfg_file()
	if theme.name == "vscode" then
		theme.cond = true
	else
		theme.cond = config.preload_colorschemes or false
	end
end

table.sort(themes, function (a, b)
	return a.name < b.name
end)

return themes
