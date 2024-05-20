require('tokyonight').setup({ 
    style="day",
    -- no italic for functions
    styles = {
        functions = {}
    },
})
vim.cmd[[colorscheme tokyonight]]
