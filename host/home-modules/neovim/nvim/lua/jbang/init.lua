local M = {}

local function get_jdtls_client(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  for _, client in ipairs(vim.lsp.get_clients({
    bufnr = bufnr,
    name = "jdtls",
  })) do
    return client
  end

  return nil
end

function M.synchronize()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)

  if filename == "" then
    vim.notify("Current buffer has no file", vim.log.levels.ERROR)
    return
  end

  local client = get_jdtls_client(bufnr)

  if not client then
    vim.notify("JDTLS is not attached to this buffer", vim.log.levels.ERROR)
    return
  end

  local uri = vim.uri_from_bufnr(bufnr)

  client:request("workspace/executeCommand", {
    command = "java.execute.workspaceCommand",
    arguments = {
      "jbang/synchronize",
      { uri },
    },
  }, function(err, result)
    if err then
      vim.notify(
        "JBang synchronization failed: " .. err.message,
        vim.log.levels.ERROR
      )
      return
    end

    vim.notify("JBang synchronization requested")
  end, bufnr)
end

vim.api.nvim_create_user_command("JbangSync", M.synchronize, {})

return M
