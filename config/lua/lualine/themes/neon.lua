-- Tema de lualine derivado de la paleta neon del wallpaper.
local palette = require("neon.palette")

local p = palette.get()
local mix = palette.mix
local solid = p.solid

local function mode(accent)
	return {
		a = { fg = solid, bg = accent, gui = "bold" },
		b = { fg = p.text, bg = mix(solid, accent, 0.10) },
		c = { fg = p.text, bg = mix(solid, accent, 0.05) },
	}
end

return {
	normal = mode(p.accent1),
	insert = mode(p.accent2),
	visual = mode(p.accent2),
	replace = mode(p.power),
	command = mode(p.power),
	terminal = mode(p.accent1),
	inactive = {
		a = { fg = p.muted, bg = mix(solid, p.accent1, 0.05) },
		b = { fg = p.muted, bg = mix(solid, p.accent1, 0.05) },
		c = { fg = p.muted, bg = mix(solid, p.accent1, 0.03) },
	},
}
