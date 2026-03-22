require("monokai-pro").setup({
  transparent_background = true,
  terminal_colors = true,
  styles = {
    comment = { italic = true },
    keyword = { italic = true },
    type = { italic = true },
    storageclass = { italic = true },
    structure = { italic = true },
    parameter = { italic = true },
    annotation = { italic = true },
    tag_attribute = { italic = true },
  },
  background_clear = {
    "telescope",
  },
  filter = "classic",
})
vim.cmd([[colorscheme monokai-pro]])
