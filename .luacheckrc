-- Estos .lua los interpreta neovim, que inyecta `vim` como global. Sin esta
-- linea luacheck marca cada uso como variable no definida y el aviso real se
-- pierde entre el ruido.
std = "min"

-- `vim` va en globals y no en read_globals porque la config le escribe
-- encima: `vim.opt.number = true` es una asignacion a un campo de `vim`, y
-- con read_globals luacheck la marca las 29 veces que ocurre.
globals = { "vim" }

-- Las tablas de config de los plugins son largas a proposito; cortarlas a 80
-- columnas las haria menos legibles, no mas.
max_line_length = false
