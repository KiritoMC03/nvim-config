-- NeoTree
vim.keymap.set('n', '<leader>nf', ':Neotree left focus<CR>')
vim.keymap.set('n', '<leader>nt', ':Neotree left toggle<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')

-- Custom
local switch_lines = function ()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
    vim.opt.number = not vim.opt.number:get()
end
vim.keymap.set('n', '<leader>dl', switch_lines)
