-- lualine con el tema que sale de la paleta del wallpaper. El modulo del tema
-- vive en lua/lualine/themes/neon.lua y se recarga desde neon/init.lua cuando
-- cambia el fondo.
return {
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			opts.options = vim.tbl_deep_extend("force", opts.options or {}, { theme = "neon" })
		end,
	},
}
