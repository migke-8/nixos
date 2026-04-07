local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capable = function(config) 
    local capable = cmp_nvim_lsp.default_capabilities()
    return vim.tbl_deep_extend("keep", config, capable)
end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    local config = capable(require("metals").bare_config())
    local result = vim.tbl_deep_extend("keep", config, {
      metalsBinaryPath = {"metals"}
    })
    require("metals").initialize_or_attach(result)
  end,
  group = nvim_metals_group,
})
vim.lsp.enable("nixd")
vim.lsp.enable("bashls")
vim.lsp.config("bashls", capable({}))

vim.lsp.enable("svelte")
vim.lsp.enable("svelte", capable({}))
vim.lsp.enable("ts_ls")
vim.lsp.config("ts_ls", capable({
  settings = {
    formatting = {
      command = {"prettier"}
    }
  }
}))

vim.filetype.add({
  extension = { ["html.mustache"] = "html" },
})
vim.lsp.config("html", {
  filetypes = { "html", "html.mustache" },
  settings = {
    formatting = {
      command = {"prettier"}

    }
  }
})
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.config("cssls", capable({
  settings = {
    formatting = {
      command = {"prettier"}
    }
  }
}))
vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls",  capable({
  cmd = {"lua-lsp"},
  settings = {
    formatting = {
      command = {"stylua"}
    }
  }
}))
vim.lsp.config("nixd", capable({
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
}))
vim.lsp.enable("clangd")
vim.lsp.config("clangd", capable({}))

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
