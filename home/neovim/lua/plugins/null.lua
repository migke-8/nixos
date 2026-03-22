-- **************
-- null-ls
-- **************
require("null-ls").setup()
vim.keymap.set({ "n", "i" }, "<C-f>", vim.lsp.buf.format, {})
