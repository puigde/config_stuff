-- Define a function to set the theme based on the time of day
local function set_tokyonight_style()
    local hour = tonumber(os.date("%H"))
    
    if hour >= 16 then
        -- After 8 PM or before 6 AM, use the night style
        require('tokyonight').setup({
            style = "night",
            styles = {
                functions = {}
            },
        })
    else
        -- Between 6 AM and 8 PM, use the day style
        require('tokyonight').setup({
            style = "day",
            styles = {
                functions = {}
            },
        })
    end
    
    -- Apply the colorscheme
    vim.cmd[[colorscheme tokyonight]]
end

-- Set the theme when Neovim starts
set_tokyonight_style()
