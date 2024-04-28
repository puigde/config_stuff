vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.showcmd = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.wo.relativenumber = true
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]])
vim.keymap.set("n", "<leader>od", ":ObsidianTemplate daily<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>om", ":ObsidianTemplate meeting<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>ow", ":ObsidianTemplate writing<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.opt.conceallevel = 1
