require('tokyonight').setup({ 
    style="night",
    -- no italic for functions
    styles = {
        functions = {}
    },
    on_colors = function(colors)
        colors.bg = "#000000"
        colors.bg_sidebar = "#000000"
        colors.fg_sidebar = "#ffffff"
    end

})
vim.cmd[[colorscheme tokyonight]]
