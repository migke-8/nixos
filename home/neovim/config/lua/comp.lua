local completionData = {
  sources = {
    {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" }
    }
  },
  icons = {
    "",
    Text = "",
    Variable = "",
    Function = "󰡱",
    Snippet = "",
    Field = "",
    Method = "",
    Keyword = "",
    Class = "",
    Module = "󱒌",
    Interface = "",
    Value = "",
    Constant = ""
  },
  getWindow = function(cmp)
    return {
      col_offset = -3,
      completion = cmp.config.window.bordered(
        {
          border = "shadow",
          scrollbar = false
        }
      ),
      documentation = { max_height = 7 }
    }
  end
}
local configure = function()
  vim.api.nvim_set_hl(0, "CmpItemKind", {
    foreground = "#AE81FF",
    background = "NONE",
    italic = true,
  })
  vim.api.nvim_set_hl(0, "CmpItemMenu", {
    foreground = "#A6E22E",
    background = "NONE",
    italic = true,
  })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", {
    foreground = "#E6DB74",
    background = "NONE",
    italic = true,
  })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", {
    foreground = "#E6DB74",
    background = "NONE",
    italic = true,
  })
  vim.cmd("set pumheight=7")
end
local cmp = require("cmp")

configure()
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = completionData.getWindow(cmp),
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<C-d>"] = cmp.mapping(function(fallback)
      if cmp.visible_docs() then
        cmp.close_docs()
      elseif cmp.visible() then
        cmp.open_docs()
      else
        fallback()
      end
    end),
  }),
  sources = cmp.config.sources(unpack(completionData.sources)),
  formatting = {
    fields = { "abbr", "menu", "kind" },
    format = function(_, vim_item)
      local icons = completionData.icons
      local kind = vim_item.kind
      local icon = icons[kind]
      local kindText = "(" .. kind:lower() .. ")"
      local expected = icon and icon .. " " .. kindText
      local default = icons[1] .. " " .. kindText

      vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
      vim_item.menu = vim_item.menu and string.sub(vim_item.menu, 1, 19)
      vim_item.kind = expected or default
      return vim_item
    end,
  },
})
