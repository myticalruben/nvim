-- Tema neon que sigue al wallpaper. La paleta la genera el dotfiles en
-- ~/.cache/waybar/palette.css (waybar/scripts/theme.sh); aqui se lee y se
-- aplica. Cuando el archivo cambia, se reaplica solo.
local palette = require("neon.palette")
local highlights = require("neon.highlights")

local M = {}

--- @param p table
local function terminal_colors(p)
	local solid, text, a1, a2 = p.solid, p.text, p.accent1, p.accent2
	local power, muted = p.power, p.muted
	local function mix(a, b, t)
		return palette.mix(a, b, t)
	end
	vim.g.terminal_color_0 = solid
	vim.g.terminal_color_1 = power
	vim.g.terminal_color_2 = a1
	vim.g.terminal_color_3 = a2
	vim.g.terminal_color_4 = a1
	vim.g.terminal_color_5 = a2
	vim.g.terminal_color_6 = mix(a1, text, 0.40)
	vim.g.terminal_color_7 = text
	vim.g.terminal_color_8 = muted
	vim.g.terminal_color_9 = mix(power, text, 0.30)
	vim.g.terminal_color_10 = mix(a1, text, 0.30)
	vim.g.terminal_color_11 = mix(a2, text, 0.30)
	vim.g.terminal_color_12 = mix(a1, text, 0.15)
	vim.g.terminal_color_13 = mix(a2, text, 0.15)
	vim.g.terminal_color_14 = a1
	vim.g.terminal_color_15 = "#ffffff"
end

--- Aplica la paleta actual a los grupos de resaltado.
function M.apply()
	local p = palette.get()
	local groups = highlights.build(p)

	for name, spec in pairs(groups) do
		if type(spec) == "string" then
			spec = { link = spec }
		end
		vim.api.nvim_set_hl(0, name, spec)
	end

	vim.o.background = "dark"
	vim.g.colors_name = "neon"
	vim.g.neon_source = p.source
	terminal_colors(p)
end

-- lualine guarda el tema ya cargado; para que siga al wallpaper hay que
-- recargar el modulo y volver a configurarlo con los opts que armo LazyVim.
local function refresh_lualine()
	if not package.loaded["lualine"] then
		return
	end
	package.loaded["lualine.themes.neon"] = nil
	if not _G.LazyVim then
		return
	end
	local ok, opts = pcall(_G.LazyVim.opts, "lualine.nvim")
	if ok and opts then
		pcall(function()
			require("lualine").setup(vim.deepcopy(opts))
		end)
	end
end

--- Reaplica la paleta y refresca los plugins que la cachean.
function M.reload()
	M.apply()
	refresh_lualine()
	vim.g.neon_generation = (vim.g.neon_generation or 0) + 1
end

local uv = vim.uv or vim.loop
local watcher
local timer = uv.new_timer()
local pending = false

local function watch()
	local dir = vim.fn.fnamemodify(palette.path(), ":h")
	if watcher then
		pcall(function()
			watcher:stop()
			watcher:close()
		end)
		watcher = nil
	end
	if vim.fn.isdirectory(dir) ~= 1 then
		return
	end
	watcher = uv.new_fs_event()
	if not watcher then
		return
	end
	local ok = watcher:start(dir, {}, function(err, fname)
		if err then
			return
		end
		if fname == nil or fname == "palette.css" then
			if not pending then
				pending = true
				timer:start(
					120,
					0,
					vim.schedule_wrap(function()
						pending = false
						M.reload()
					end)
				)
			end
		end
	end)
	if not ok then
		pcall(function()
			watcher:close()
		end)
		watcher = nil
	end
end

function M.setup()
	if M.did_setup then
		M.reload()
		return
	end
	M.did_setup = true

	M.apply()
	watch()

	local group = vim.api.nvim_create_augroup("NeonWallpaper", { clear = true })

	-- Algunos plugins crean sus grupos al cargarse; se reaplica el tema para
	-- que no se queden con los colores del colorscheme anterior.
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "LazyLoad",
		callback = function()
			vim.schedule(M.apply)
		end,
	})

	-- Si el usuario cambia de colorscheme a mano, el neon vuelve a mandar.
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			vim.schedule(M.apply)
		end,
	})

	vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
		group = group,
		callback = function()
			watch()
			M.reload()
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			if watcher then
				pcall(function()
					watcher:stop()
					watcher:close()
				end)
			end
			timer:stop()
			timer:close()
		end,
	})

	vim.api.nvim_create_user_command("NeonReload", function()
		M.reload()
		vim.notify("Paleta neon recargada desde " .. palette.get().source, vim.log.levels.INFO)
	end, { desc = "Relee la paleta del wallpaper y reaplica el tema" })

	vim.api.nvim_create_user_command("NeonPalette", function()
		local p = palette.get()
		vim.notify(
			string.format(
				"neon: %s · acento %s / %s · fondo %s (alpha %.2f)",
				p.source,
				p.accent1,
				p.accent2,
				p.solid,
				p.bg_alpha
			)
		)
	end, { desc = "Muestra la paleta neon actual" })
end

return M
