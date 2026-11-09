-- DAP queda fuera a proposito hasta que las plantillas traigan adaptadores
-- (codelldb, debugpy, java-debug). nvim-dap no tiene `setup()`, asi que LazyVim
-- intenta configurarlo con su config por defecto y falla en cuanto
-- rustaceanvim lo carga. Sin config no hay debug, pero tampoco error.
return {
	{ "mfussenegger/nvim-dap", config = function() end },
}
