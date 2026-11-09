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
