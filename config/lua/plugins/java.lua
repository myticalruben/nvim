-- nvim-jdtls necesita el jar de java-debug al arrancar. LazyVim lo busca en
-- Mason; la plantilla java lo deja en JAVA_DEBUG_BUNDLES.
return {
	{
		"mfussenegger/nvim-jdtls",
		opts = function(_, opts)
			local bundles = vim.split(vim.env.JAVA_DEBUG_BUNDLES or "", ":", { trimempty = true })
			if #bundles > 0 then
				opts.jdtls = opts.jdtls or {}
				opts.jdtls.init_options =
					vim.tbl_deep_extend("force", opts.jdtls.init_options or {}, { bundles = bundles })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		init = function()
			-- setup_dap necesita el cliente jdtls ya enganchado, asi que va en
			-- LspAttach y no en opts.
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "jdtls" and (vim.env.JAVA_DEBUG_BUNDLES or "") ~= "" then
						require("jdtls").setup_dap({ hotcodereplace = "auto" })
					end
				end,
			})
		end,
	},
}
