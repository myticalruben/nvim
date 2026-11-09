-- Ajustes de los adaptadores que configura LazyVim. El binario lo pone el
-- devShell del proyecto; aqui solo se corrige como se conecta.
return {
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			-- codelldb escucha en IPv4 y "localhost" puede resolver a ::1
			-- primero: la conexion se quedaba en ECONNREFUSED.
			if dap.adapters.codelldb then
				dap.adapters.codelldb.host = "127.0.0.1"
			end
		end,
	},
}
