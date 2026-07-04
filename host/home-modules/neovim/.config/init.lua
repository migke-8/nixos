-- **************
-- plugins
-- **************
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

require("oil").setup({
  default_file_explorer = true,
  columns = {
    "size",
    "icon",
  },
  keymaps = {
    ["<leader>rf"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
  },
  view_options = {
    show_hidden = true,
    is_hidden_file = function(name, _)
      return vim.startswith(name, ".")
    end,
    case_insensitive = false,
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
    is_always_hidden = function(name, _)
      if name == ".." or name == ".git" then
        return true
      end
      return false
    end,
  },
})
vim.keymap.set("n", "-", function()
  require("oil").open()
end)
-- **************
-- editor config
-- **************
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")
vim.cmd("set expandtab")
vim.cmd("set ignorecase")
vim.cmd("set history=1000")
vim.cmd("set wildmenu")
vim.cmd("set relativenumber")
vim.cmd("set clipboard+=unnamedplus")
vim.cmd("set noswapfile")
vim.cmd("set cmdheight=2")
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.shell = "zsh"
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
-- **************
-- keymaps config
-- **************
local doKeyStroke = function(keys_to_type)
  local replaced_keys = vim.api.nvim_replace_termcodes(keys_to_type, true, false, true)
  vim.api.nvim_feedkeys(replaced_keys, 'm', false)
end
local string = require("string")
local augroup = vim.api.nvim_create_augroup("buffer_events", { clear = true })
local isTerm = function()
  return vim.api.nvim_buf_get_option(0, "buftype") == "terminal"
end
local isInTermNormal = function()
  local in_terminal = vim.v.mode ~= 't'
  local is_terminal_buffer = vim.bo.buftype == 'terminal'
  return in_terminal and is_terminal_buffer
end
vim.keymap.set("n", "<C-d>", "<C-d>zz", {noremap = true, silent = true})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {noremap = true, silent = true})
vim.keymap.set("n", "n", "nzzzv", {noremap = true, silent = true})
vim.keymap.set("n", "N", "Nzzzv", {noremap = true, silent = true})
vim.keymap.set({"n", "t"}, "<C-]>", function() vim.cmd("rightbelow vnew") end, {noremap = true, silent = true})
vim.keymap.set({"n", "t"}, "<Esc>", "<Esc>", {noremap = true, silent = true})
vim.keymap.set({"n", "t"}, "<C-[>", function() vim.cmd("leftabove vnew") end, {noremap = true, silent = true})
vim.keymap.set({"n", "t"}, "<A-->", function() vim.cmd("rightbelow new") end, {noremap = true, silent = true})
vim.keymap.set({"n", "t"}, "<A-=>", function() vim.cmd("new") end, {noremap = true, silent = true})
vim.keymap.set("n", "<C-t>", function()
  if not isTerm() then
    vim.cmd("terminal")
    vim.cmd("set nospell")
  end
  doKeyStroke("a")
end)
vim.keymap.set({"n", "t"}, "<leader>n", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-t>", "<leader>n")
vim.keymap.set({"n", "t"}, "<C-Tab>", function()
  vim.cmd("bnext")
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
      if isInTermNormal() then
        doKeyStroke("a")
      end
    end,
    pattern = "*",
    once = true
  })
end)
vim.keymap.set({"n", "t"}, "<S-Tab>", function()
  vim.cmd("bp")
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
      if isInTermNormal() then
        doKeyStroke("a")
      end
    end,
    pattern = "*",
    once = true
  })

end)
vim.keymap.set({"n", "t"}, "<leader>w", function()
  if isTerm() then
    doKeyStroke("<leader>n<C-w>")
  else
    doKeyStroke("<C-w>")
    doKeyStroke(string.char(vim.fn.getchar()))
    vim.api.nvim_create_autocmd("BufEnter", {
      group = augroup,
      callback = function()
        if isInTermNormal() then
          doKeyStroke("a")
        end
      end,
      pattern = "*",
      once = true
    })
  end
end)

