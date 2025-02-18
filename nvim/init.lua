-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set the background dynamically based on Ghostty config
local function get_ghostty_background()
	local output = vim.fn.system("ghostty +show-config")
	for line in output:gmatch("[^\r\n]+") do
		if line:find("background") then
			local bg = line:match("background = #(.-)$")
			return bg
		end
	end
	return "ffffff" -- Default color if not found
end
local ghostty_background = get_ghostty_background()
vim.o.background = ghostty_background == "ffffff" and "light" or "dark"

-- General keymaps and opt
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.showcmd = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.wo.relativenumber = true
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>od", ":ObsidianTemplate daily<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>om", ":ObsidianTemplate meeting<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>ow", ":ObsidianTemplate writing<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>op", ":ObsidianTemplate paperdoc<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>on", ":ObsidianTemplate papernote<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>omoc", ":ObsidianTemplate moc<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>or", ":ObsidianTemplate review<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.keymap.set("n", "<leader>ps", ":ObsidianTemplate projectsummary<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>")
vim.opt.conceallevel = 1

-- Common variables
local obsidian_vault_path = "/Users/polpuigdemont/Documents/obsfiles/Obsidian Vault/"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- PLUGINS
		-- * Tokyonight
		{
			"folke/tokyonight.nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
			config = function()
				-- load the colorscheme here
				require("tokyonight").setup({
					style = "night", -- Set to "day" mode
					transparent = true, -- Enable transparency
					styles = {
						sidebars = "transparent",
						floats = "transparent",
					},
				})
				vim.cmd([[colorscheme tokyonight]])
			end,
		},
		-- * Telescope
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.4", -- Optional, you can specify a version if needed
			dependencies = { "nvim-lua/plenary.nvim" }, -- Telescope depends on plenary.nvim
			cmd = "Telescope", -- Lazy load on :Telescope command
			keys = {
				{
					"<leader>ff",
					function()
						require("telescope.builtin").find_files()
					end,
					desc = "Find Files",
				},
				{
					"<leader>fg",
					function()
						require("telescope.builtin").live_grep()
					end,
					desc = "Live Grep",
				},
				{
					"<leader>og",
					function()
						require("telescope.builtin").live_grep({
							search_dirs = { obsidian_vault_path },
						})
					end,
					desc = "Grep Obsidian",
				},
			},
			opts = {
				defaults = {
					layout_strategy = "horizontal",
					sorting_strategy = "ascending",
					layout_config = { prompt_position = "bottom" },
				},
			},
		},
		-- * Obsidian
		{
			"epwalsh/obsidian.nvim",
			dependencies = { "nvim-lua/plenary.nvim" }, -- Dependency for the plugin
			cond = function()
				return vim.loop.os_uname().sysname == "Darwin" -- Only load on macOS
			end,
			opts = {
				workspaces = {
					{
						name = "puigde", -- Name of the workspace
						path = obsidian_vault_path, -- Path to your Obsidian Vault
					},
				},
				notes_subdir = "cache",
				new_notes_location = "notes_subdir",
				disable_frontmatter = true,
				templates = {
					subdir = "templates",
					date_format = "%Y-%m-%d",
					time_format = "%H:%M:%S",
				},
				completion = {
					nvim_cmp = true, -- Enable nvim-cmp completion
					min_chars = 2, -- Trigger completion after 2 characters
				},
				mappings = {
					-- Custom key mapping to override 'gf' for markdown links
					["gf"] = {
						action = function()
							return require("obsidian").util.gf_passthrough()
						end,
						opts = { noremap = false, expr = true, buffer = true },
					},
				},
			},
		},
		-- * Nvim-cmp (required for Obsidian)
		{
			"hrsh7th/nvim-cmp",
		},
		-- * Lualine
		{
			"nvim-lualine/lualine.nvim",
			opts = {
				options = {
					theme = "auto", -- Manually set your preferred theme, or keep it as "auto"
				},
			},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
