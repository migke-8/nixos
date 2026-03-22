require("comp")
require("treesitter")
require("lsp")
require("line")
require("org")
require("null")
require("finder")
require("file")
require("theme")
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
