local M = {}

vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<S-f>', '*', { noremap = true, silent = true })

--------

function M.switch_lines()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
    vim.opt.number = not vim.opt.number:get()
end
vim.keymap.set('n', '<leader>dl', M.switch_lines, { desc = "Switch lines mode" })

--------

return M
