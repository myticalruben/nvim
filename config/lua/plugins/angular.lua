-- El extra `lang.angular` da por hecho Mason: busca el plugin de Angular en
-- ~/.local/share/nvim/mason/packages y, sin Mason, deja un aviso y una ruta
-- que no existe. La plantilla del proyecto ya trae el binario
-- `ngserver` (angular-language-server), asi que configuramos solo el servidor.
--
-- `angularls` se declara para typescript/html por defecto, asi que sin filtro
-- intentaria arrancar en cualquier .ts (una shell de React no trae ngserver y
-- suelta un error de spawn). Solo se activa donde el binario exista, y ademas
-- exige angular.json/nx.json en la raiz.
return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers.angularls = vim.fn.executable("ngserver") == 1 and { workspace_required = true }
				or { enabled = false }
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "angular", "scss" } },
	},
}
