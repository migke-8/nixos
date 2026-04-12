local cmp_nvim_lsp = require("cmp_nvim_lsp")
local chosen_java_option = nil
local metals_initialized = false
local capable = function(config) 
    local capable = cmp_nvim_lsp.default_capabilities()
    return vim.tbl_deep_extend("keep", config, capable)
end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

local initiliaze_metals = function(metals) 
  if not metals_initialized then 
    local config = capable(require("metals").bare_config())
    local result = vim.tbl_deep_extend("keep", config, {
      metalsBinaryPath = {"metals"}
    })
    metals_initialized = true
    require("metals").initialize_or_attach(result)
  end
end
local initialize_jdtls = function(jdtls) 
  local root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', 'build.sbt', "flake.nix"})
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

  local config = {
    cmd = {
      "jdtls",
      "-configuration", vim.fn.stdpath("cache") .. "/jdtls-config",
      "-data", workspace_dir
    },
    root_dir = root_dir,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
      },
    },
  }
  jdtls.start_or_attach(config)
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  callback = initiliaze_metals,
  group = nvim_metals_group,
})
local function prompt_java_lsp()
  local options = { "jdtls", "metals", "none" }

  vim.ui.select(options, {
    prompt = "Select Java Language Server:",
    format_item = function(item)
      if item == "jdtls" then return "Eclipse JDTLS (Standard Java)" end
      if item == "metals" then return "Scala Metals (Scala/Java Hybrid)" end
      return "None (Skip LSP)"
    end,
  }, function(choice)
      chosen_java_option = choice
    if choice == "jdtls" then
        local status, jdtls = pcall(require, "jdtls")
      if status then
          initialize_jdtls(jdtls)
        else
          print("Error: nvim-jdtls not found.")
        end
      elseif choice == "metals" then
        local status, metals = pcall(require, "metals")
        if status then
          initiliaze_metals(metals)
        else
          print("Error: nvim-metals not found.")
        end
      end
    end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    if chosen_java_option == nil then
      prompt_java_lsp()
    elseif chosen_java_option == "jdtls" then
      require("jdtls").initialize_or_attach()
    end
  end,
})

vim.lsp.enable("nixd")
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

