vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup()

vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
-- set the command to go to the tree when opened to be leader rt
vim.api.nvim_set_keymap('n', '<leader>rt', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
