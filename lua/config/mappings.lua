vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<S-f>', '*', { noremap = true, silent = true })

--------

local switch_lines = function ()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
    vim.opt.number = not vim.opt.number:get()
end
vim.keymap.set('n', '<leader>dl', switch_lines, { desc = "Switch lines mode" })

--------
