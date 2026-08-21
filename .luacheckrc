-- Estos .lua los interpreta neovim, que inyecta `vim` como global. Sin esta
-- linea luacheck marca cada uso como variable no definida y el aviso real se
-- pierde entre el ruido.
std = "min"
read_globals = { "vim" }

-- Las tablas de config de los plugins son largas a proposito; cortarlas a 80
-- columnas las haria menos legibles, no mas.
max_line_length = false
