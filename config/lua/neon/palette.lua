-- Lee la paleta neon que genera el dotfiles a partir del wallpaper:
-- waybar/scripts/theme.sh escribe `@define-color neon_*` en
-- ~/.cache/waybar/palette.css, y de ahi beben waybar y GTK. nvim usa el mismo
-- archivo para que el editor cambie con el fondo.
local M = {}

local FALLBACK = {
	solid = "#05080f",
	accent1 = "#00f0ff",
	accent2 = "#ff2bd6",
	text = "#d9fbff",
	muted = "#5e6b86",
	power = "#ff4d6d",
	bg_alpha = 0.20,
}

local function normalize(hex)
	if type(hex) ~= "string" then
		return nil
	end
	local h = hex:gsub("^#", "")
	if #h == 3 then
		h = h:gsub("(.)", "%1%1")
	end
	if #h ~= 6 or h:find("%X") then
		return nil
	end
	return "#" .. h:lower()
end

local function parse_rgba(value)
	local r, g, b, a = (value or ""):match("rgba%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*,%s*([%d%.]+)%s*%)")
	if not r then
		return nil
	end
	return { r = tonumber(r), g = tonumber(g), b = tonumber(b), a = tonumber(a) }
end

--- Ruta de la paleta. Se puede forzar con $NVIM_NEON_PALETTE (util para probar).
function M.path()
	local cache = vim.env.XDG_CACHE_HOME
	if not cache or cache == "" then
		cache = (vim.env.HOME or "") .. "/.cache"
	end
	return vim.env.NVIM_NEON_PALETTE or (cache .. "/waybar/palette.css")
end

--- Devuelve la paleta actual. Si el archivo no existe o esta incompleto, usa
--- los valores por defecto del dotfiles (los mismos de waybar/style.css).
function M.get()
	local colors = vim.deepcopy(FALLBACK)
	local path = M.path()
	local raw = ""
	local f = io.open(path, "r")
	if f then
		raw = f:read("*a") or ""
		f:close()
	end

	local defs = {}
	for name, value in raw:gmatch("@define%-color%s+([%w_]+)%s+([^;]+);") do
		defs[name] = value:match("^%s*(.-)%s*$")
	end

	colors.solid = normalize(defs.neon_solid) or colors.solid
	colors.accent1 = normalize(defs.neon_accent1) or colors.accent1
	colors.accent2 = normalize(defs.neon_accent2) or colors.accent2
	colors.text = normalize(defs.neon_text) or colors.text
	colors.muted = normalize(defs.neon_muted) or colors.muted
	colors.power = normalize(defs.neon_power) or colors.power

	local bg = parse_rgba(defs.neon_bg)
	if bg then
		colors.bg_alpha = bg.a
	end

	colors.source = raw ~= "" and path or "fallback"
	return colors
end

--- Mezcla dos colores hex: t=0 devuelve `a`, t=1 devuelve `b`.
function M.mix(a, b, t)
	a, b = normalize(a), normalize(b)
	if not a or not b then
		return a or b
	end
	local function comp(h, i)
		-- i=1,3,5 sobre "rrggbb": el "#" ocupa la posicion 1.
		return tonumber(h:sub(i + 1, i + 2), 16)
	end
	local out = { "#" }
	for _, i in ipairs({ 1, 3, 5 }) do
		local v = math.floor(comp(a, i) * (1 - t) + comp(b, i) * t + 0.5)
		out[#out + 1] = string.format("%02x", math.min(255, math.max(0, v)))
	end
	return table.concat(out)
end

return M
