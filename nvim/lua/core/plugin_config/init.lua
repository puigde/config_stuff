require('core.plugin_config.lualine')
require('core.plugin_config.telescope')
require('core.plugin_config.tokyonight')
local uname = vim.loop.os_uname()
if uname.sysname == "Darwin" then
    require('core.plugin_config.obsidian')
end
