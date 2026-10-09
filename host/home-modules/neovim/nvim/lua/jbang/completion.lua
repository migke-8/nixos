local M = {}

local directives = {
  "DEPS",
  "REPOS",
  "JAVA",
  "PREVIEW",
  "COMPILE_OPTIONS",
  "RUNTIME_OPTIONS",
  "JAVAC_OPTIONS",
  "JAVA_OPTIONS",
  "NATIVE_OPTIONS",
  "SOURCES",
  "FILES",
  "MAIN",
  "MODULE",
  "MANIFEST",
  "CDS",
  "JAVAAGENT",
  "KOTLIN",
  "GROOVY",
  "DESCRIPTION",
}

local function complete_directives(buf)
  if not vim.api.nvim_buf_is_valid(buf)
    or not vim.api.nvim_get_mode().mode:match("^i")
    or vim.fn.pumvisible() == 1
  then
    return
  end

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)
  local prefix = before:match("^%s*//([%w_]*)$")

  if prefix == nil then
    return
  end

  local items = {}

  for _, name in ipairs(directives) do
    if name:sub(1, #prefix) == prefix then
      items[#items + 1] = {
        word = name,
        menu = "[JBang]",
      }
    end
  end

  if #items > 0 then
    vim.fn.complete(col - #prefix + 1, items)
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup(
    "JBangCompletion",
    { clear = true }
  )

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "java",
    callback = function(ev)
      vim.api.nvim_create_autocmd("TextChangedI", {
        group = group,
        buffer = ev.buf,
        callback = function()
          vim.schedule(function()
            complete_directives(ev.buf)
          end)
        end,
      })
    end,
  })
end

return M

