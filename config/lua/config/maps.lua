local opts = { silent = true }
local keymap = vim.keymap.set

--Delete a word backwards and duplicate an line
keymap("n", "dw", 'vb"_d')
keymap("n", "dl", ":t.<CR>")

--split window
keymap("n", "ss", ":split<Return><C-w>w", opts)
keymap("n", "sv", ":vsplit<Return><C-w>w", opts)

--Exit, save and quit
keymap("i", "jk", "<esc>", opts)
keymap("n", "gh", ":w<CR>", opts)
keymap("n", "el", ":q<CR>", opts)

--Move window
keymap("n", "<Space>", "<C-w>w")
keymap("n", "sh", "<C-w>h")
keymap("n", "sk", "<C-w>k")
keymap("n", "sj", "<C-w>j")
keymap("n", "sl", "<C-w>l")

-- Reinicia nvim para recargar la config sin cerrar la terminal. Guarda la
-- sesion y la restaura, asi siguen abiertos los mismos buffers.
-- La copia de la config (~/.config/nvim-nix) la refresca el wrapper del
-- paquete, no este proceso. Arrancarlo aqui hace ese sync si acabas de
-- actualizar el paquete; --clean evita cargar la config dos veces.
local function sync_config()
	local wrapper = vim.fn.exepath("nvim")
	if wrapper == "" or wrapper == vim.v.argv[1] then
		return
	end
	vim.fn.system({ wrapper, "--clean", "--headless", "+qa" })
end

local function reset_nvim()
	local modified = vim.tbl_filter(function(buf)
		return vim.bo[buf].modified
	end, vim.api.nvim_list_bufs())
	if #modified > 0 then
		vim.notify("Guarda los buffers modificados antes de reiniciar", vim.log.levels.WARN)
		return
	end
	sync_config()
	local session = vim.fn.stdpath("state") .. "/reset-session.vim"
	vim.cmd("mksession! " .. vim.fn.fnameescape(session))
	-- Noice no maneja el evento "restart" del TUI y deja un error en el log.
	-- Se desengancha antes; si el restart falla, se vuelve a enganchar.
	local ok_noice, noice_ui = pcall(require, "noice.ui")
	if ok_noice and noice_ui.disable then
		noice_ui.disable()
	end
	if not pcall(vim.cmd, "restart source " .. vim.fn.fnameescape(session)) then
		if ok_noice and noice_ui.enable then
			noice_ui.enable()
		end
	end
end

vim.api.nvim_create_user_command("NvimReset", reset_nvim, { desc = "Reinicia nvim y recarga la config" })

keymap("n", "<leader>uR", "<cmd>NvimReset<cr>", { silent = true, desc = "Reiniciar nvim (recargar config)" })
