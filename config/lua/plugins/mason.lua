-- Las herramientas las pone el devShell del proyecto (nix-templates), no este
-- paquete. Mason sobra: bajaria otra vez lo mismo y su binario taparia al del
-- proyecto, que es justo lo que queremos evitar.
return {
	{ "mason-org/mason.nvim", enabled = false },
	{ "mason-org/mason-lspconfig.nvim", enabled = false },
	-- Depende de mason.nvim y LazyVim lo cargaria al arrancar nvim-dap.
	{ "jay-babu/mason-nvim-dap.nvim", enabled = false },
}
