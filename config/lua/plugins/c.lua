-- Lo que LazyVim espera de Mason para C/C++, resuelto con lo que trae la
-- plantilla del proyecto.
return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			-- clangd 21 ya no acepta `--function-arg-placeholders` sin valor.
			local clangd = opts.servers and opts.servers.clangd
			for i, arg in ipairs((clangd and clangd.cmd) or {}) do
				if arg == "--function-arg-placeholders" then
					clangd.cmd[i] = "--function-arg-placeholders=1"
				end
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		-- clang-format lo trae la plantilla; sin esto el formateo caia en
		-- clangd (estilo llvm y sin .clang-format propio).
		opts = { formatters_by_ft = { c = { "clang_format" }, cpp = { "clang_format" } } },
	},
}
