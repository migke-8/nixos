-- **************
-- null-ls
-- **************
local null_ls = require("null-ls") 
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
    },
})
vim.keymap.set({ "n", "i" }, "<C-f>", vim.lsp.buf.format, {})
