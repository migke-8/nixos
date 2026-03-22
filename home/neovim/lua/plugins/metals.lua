local cmp_nvim_lsp = require("cmp_nvim_lsp")
local metals_config = require("metals").bare_config()

metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    local capable = cmp_nvim_lsp.default_capabilities()
    local configuration = vim.tbl_deep_extend("keep", metals_config, capable)
    require("metals").initialize_or_attach(configuration)
  end,
  group = nvim_metals_group,
})
