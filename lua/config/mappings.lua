local M = {}

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<S-f>", "*", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-s>", ":ConfigUI<CR>")

--------

function M.switch_lines()
	local ok_rel, relativenumber = pcall(function()
		vim.wo.relativenumber:get()
	end)
	local ok_num, number = pcall(function()
		vim.wo.number:get()
	end)

	if not ok_rel or not ok_num then
		relativenumber = true
		number = false
	end
	vim.opt.relativenumber = not relativenumber
	vim.opt.number = not number
end
vim.keymap.set("n", "<leader>dl", M.switch_lines, { desc = "Switch lines mode" })

--------

---@param use_sys_clipboard boolean
function M.switch_yank_sys(use_sys_clipboard)
	local prefix = ""
	if use_sys_clipboard then
		prefix = '"+'
	else
		prefix = ""
	end
	vim.keymap.set("n", "y", prefix .. "y")
	vim.keymap.set("n", "yy", prefix .. "yy")
	vim.keymap.set("n", "Y", prefix .. "Y")
	vim.keymap.set("x", "y", prefix .. "y")
	vim.keymap.set("x", "Y", prefix .. "Y")
end

--------

---@param enabled boolean
function M.switch_ctrl_z(enabled)
	local modes = { "n", "i", "v" }

	for _, mode in ipairs(modes) do
		if enabled then
			vim.keymap.set(
				mode,
				"<C-z>",
				mode == "i" and "<C-o>u" or "" .. "u",
				{ noremap = true, silent = true, desc = "Undo" }
			)
		else
			pcall(vim.keymap.del, mode, "<C-z>")
		end
	end
end

--------

---@param enabled boolean
function M.switch_undo_stack(enabled)
	local modes = { "n" }

	for _, mode in ipairs(modes) do
		if enabled then
			vim.keymap.set(mode, "<leader>u", function()
				require("config.utils.root").popups.show_undo_popup(vim.api.nvim_get_current_buf())
			end, { desc = "Show undo stack" })
		else
			pcall(vim.keymap.del, mode, "<leader>u")
		end
	end
end

--------

---@param enabled boolean
function M.switch_ctrl_s(enabled)
	local modes = { "n", "i", "v" }

	for _, mode in ipairs(modes) do
		if enabled then
			vim.keymap.set(mode, "<C-s>", "<Cmd>w<CR>", { noremap = true, silent = true, desc = "Save" })
			vim.keymap.set(mode, "<A-s>", "<Cmd>wa<CR>", { noremap = true, silent = true, desc = "Save all" })
		else
			pcall(vim.keymap.del, mode, "<C-s>")
			pcall(vim.keymap.del, mode, "<A-s>")
		end
	end
end

--------

local map_go_line = function(keys, label, motion)
	vim.keymap.set("n", "<leader>j" .. keys, function()
		local n = tonumber(vim.fn.input(label))
		if n then
			vim.cmd("normal! " .. n .. motion)
		end
	end, { desc = label })
end

map_go_line("j", "Jump down by: ", "j")
map_go_line("k", "Jump up by: ", "k")

--------

M.telescope = {
	{
		"<leader>ff",
		":Telescope find_files<CR>",
		desc = "Find Files",
	},
	{
		"<leader>fp",
		"<cmd>Telescope project display_type=full<cr>",
		desc = "Find Plugin File",
	},
	{
		"<leader>ft",
		":Telescope live_grep<CR>",
		desc = "Find text everywhere",
	},
	{
		"<leader>fh",
		":Telescope current_buffer_fuzzy_find<CR>",
		desc = "Find in file",
	},
}

M.lsp = {
	-- stylua: ignore start
	{ "[d", function() vim.lsp.diagnostic.goto_prev()end, desc = "lsp goto prev diagnostic" },
	{ "]d", function() vim.lsp.diagnostic.goto_next()end, desc = "lsp goto next diagnostic" },
	{ "gD", "<cmd>Trouble lsp_declarations<cr>", desc = "lsp declaration" },
	{ "gd", "<cmd>Trouble lsp_definitions<cr>", desc = "lsp definition" },
	{ "gi", "<cmd>Trouble lsp_implementations<cr>", desc = "lsp implementation" },
	{ "gk", function() vim.lsp.buf.hover()end, desc = "lsp hover" },
	{ "gr", "<cmd>Trouble lsp_references<cr>", desc = "lsp references" },
	{ "gy", "<cmd>Trouble lsp_type_definitions<cr>", desc = "lsp type definition" },
	-- stylua: ignore start
}

M.diffview = {
	{
		"<leader>gdf",
		":DiffviewOpen<CR>",
		desc = "Git view difference",
	},
	{
		"<leader>gdh",
		":DiffviewFileHistory %<CR>",
		desc = "Git file history",
	},
	{
		"<leader>gdc",
		":DiffviewClose<CR>",
		desc = "Git diff close",
	},
}

--- Mappings for git blame visualizer
M.blame = {
	{
		"<leader>gv",
		":BlameToggle window<CR>",
		desc = "Git visualize changes",
	},
}

--- Mappings for easy-dotnet utils
M.easy_dotnet = {
	-- stylua: ignore start 
	-- { "<leader>nb", function() require("easy-dotnet").build_default_quickfix() end, desc = "build" },
	{ "<leader>.netB", function() require("easy-dotnet").build_quickfix() end, desc = "build solution" },
	{ "<leader>.netn", function() require("easy-dotnet").run_default() end, desc = "run" },
	{ "<leader>.netR", function() require("easy-dotnet").run_solution() end, desc = "run solution" },
	{ "<leader>.netx", function() require("easy-dotnet").clean() end, desc = "clean solution" },
	{ "<leader>.neta", "<cmd>Dotnet new<cr>", desc = "new item" },
	{ "<leader>.nett", "<cmd>Dotnet testrunner<cr>", desc = "open test runner" },
	-- stylua: ignore end
}

--- Mappings for conform formatter
M.conform = {
	{
		"<leader>cf",
		function()
			require("conform").format()
		end,
		desc = "Format code",
	},
}

--- Mappings for neo-tree explorer
M.neo_tree = {
	{
		"<leader>nf",
		":Neotree left focus<CR>",
		desc = "Explorer focus",
	},
	{
		"<leader>nt",
		":Neotree left toggle<CR>",
		desc = "Explorer toggle",
	},
	{
		"<leader>fr",
		":Neotree reveal<CR>",
		desc = "Reveal file",
	},
}

local barbar_key_opts = {
	noremap = true,
	silent = true,
}

local function generate_barbar_gotos(up_to)
	local keys = {}
	for i = 1, up_to do
		table.insert(keys, {
			"<A-" .. i .. ">",
			"<Cmd>BufferGoto " .. i .. "<CR>",
			desc = "Go to tab" .. i,
			barbar_key_opts,
		})
	end
	return keys
end

--- Mappings for barbar tabs
M.barbar = vim.list_extend({
	{
		"<A-.>",
		"<Cmd>BufferNext<CR>",
		barbar_key_opts,
	},
	{
		"<A-,>",
		"<Cmd>BufferPrevious<CR>",
		barbar_key_opts,
	},
	{
		"<A-c>",
		"<Cmd>BufferClose<CR>",
		barbar_key_opts,
	},
}, generate_barbar_gotos(9))

--- Mappings for dropbar breadcrubms
M.dropbar = {
	{
		"<leader>;",
		"<cmd>lua vim.g.dropbarapi.pick()<CR>",
		desc = "Pick symbols in winbar",
	},
	{
		"[;",
		"<cmd>lua vim.g.dropbarapi.goto_context_start()<CR>",
		desc = "Go to start of current context",
	},
	{
		"];",
		"<cmd>lua vim.g.dropbarapi.select_next_context()<CR>",
		desc = "Select next context",
	},
}

--- Mappings for which-key
M.which_key = {
	{
		"<leader>?",
		function()
			require("which-key").show({ global = false })
		end,
		desc = "Buffer Keymaps (which-key)",
	},
	{
		"<c-w><space>",
		function()
			require("which-key").show({ keys = "<c-w>", loop = true })
		end,
		desc = "Window Hydra Mode (which-key)",
	},
}

--- Mappings for trouble finder
M.trouble = {
	{
		"<leader>xx",
		"<cmd>Trouble diagnostics toggle<cr>",
		desc = "Diagnostics (Trouble)",
	},
	{
		"<leader>xX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		desc = "Buffer Diagnostics (Trouble)",
	},
	{
		"<leader>cs",
		"<cmd>Trouble symbols toggle focus=false<cr>",
		desc = "Symbols (Trouble)",
	},
	{
		"<leader>cl",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		desc = "LSP Definitions / references / ... (Trouble)",
	},
	{
		"<leader>xL",
		"<cmd>Trouble loclist toggle<cr>",
		desc = "Location List (Trouble)",
	},
	{
		"<leader>xQ",
		"<cmd>Trouble qflist toggle<cr>",
		desc = "Quickfix List (Trouble)",
	},
}

--------

return M
