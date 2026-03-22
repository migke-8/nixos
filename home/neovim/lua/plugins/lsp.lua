vim.lsp.enable("nixd")
vim.lsp.enable("svelte")
vim.lsp.enable("ts_ls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.config("nixd", {
  cmd = {"nixd"},
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }"
      },
      formatting = {
        command = {"alejandra"}
      }
    }
  }
})
vim.lsp.enable("clangd")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  severity_sort = true,
})


vim.keymap.set("n", "<C-x>", function()
  vim.diagnostic.open_float(nil, { focus = false })
end)
vim.keymap.set("n", "H", vim.lsp.buf.hover, {})
vim.keymap.set("n", "S", vim.lsp.buf.signature_help, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "sdc", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "sdf", vim.lsp.buf.definition, {})
vim.keymap.set("n", "sim", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "rnm", vim.lsp.buf.rename, {})
