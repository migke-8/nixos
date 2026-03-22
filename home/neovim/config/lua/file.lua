return function()
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
end
