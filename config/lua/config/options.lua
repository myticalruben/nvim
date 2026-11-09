-- LazyVim carga este archivo DESPUES de sus propios defaults, asi que lo que
-- pongas aqui gana. No lo requires desde init.lua: si lo haces, LazyVim lo
-- vuelve a pisar al arrancar.
--
-- Todo lo que no este aqui viene de LazyVim (numeros, expandtab, shiftwidth,
-- clipboard, cursorline, termguicolors, formatoptions...). Solo va lo que se
-- aparta de su valor.

-- Python: la plantilla del proyecto trae ruff (lint/formato) y pyright (tipos).
-- Con "pyright", LazyVim activa pyright Y ruff.
vim.g.lazyvim_python_lsp = "pyright"

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.pumblend = 5
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
