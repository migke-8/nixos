local dap, dapui = require("dap"), require("dapui")
local extension_path = vim.fn.glob("/nix/store/*vscode-extension-vadimcn-vscode-lldb*/share/vscode/extensions/vadimcn.vscode-lldb/")
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

vim.g.rustaceanvim = {
  server = {
    cmd = function() return { "rust-analyzer" } end,
    on_attach = function(client, bufnr)
      local opts = { buffer = bufnr }
      vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp('codeAction') end, opts)
      vim.keymap.set("n", "K", function() vim.cmd.RustLsp('hoverActions') end, opts)
      vim.keymap.set("n", "<leader>rd", function() vim.cmd.RustLsp('debuggables') end, opts)

      -- lsp
      vim.keymap.set("n", "<C-x>", function()
        vim.diagnostic.open_float(nil, { focus = false })
      end)
      vim.keymap.set("n", "H", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "S", vim.lsp.buf.signature_help, opts) 
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "sdc", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "sdf", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "sim", vim.lsp.buf.implementation, opts)

      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,
  },
  dap = {
    adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb_path, liblldb_path),
  },
}

dapui.setup()

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = "Toggle Debugger UI" })
vim.keymap.set('n', '<leader>di', function() dapui.eval() end, { desc = "Hover Variable Info" })
vim.keymap.set('n', '<leader>dq', dap.terminate, { desc = "Terminate Debugger" })
