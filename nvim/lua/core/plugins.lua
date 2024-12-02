local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'evanleck/vim-svelte'
  use 'wbthomason/packer.nvim'
  use 'nvim-lualine/lualine.nvim'
  use {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.4',
      requires = { {'nvim-lua/plenary.nvim'} }
  }
  use "folke/tokyonight.nvim"
  use "mg979/vim-visual-multi"
  use "hrsh7th/nvim-cmp"
  use {
    "epwalsh/obsidian.nvim",
    tag = "*",
    requires = { {"nvim-lua/plenary.nvim"} },
    cond = vim.loop.os_uname().sysname == "Darwin"
}
  if packer_bootstrap then
    require('packer').sync()
  end
end)
