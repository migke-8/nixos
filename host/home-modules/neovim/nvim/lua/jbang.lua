local M = {}

local function current_file()
    local bufnr = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(bufnr)

    if file == "" then
        vim.notify("No file is open", vim.log.levels.ERROR)
        return
    end

    if vim.bo[bufnr].modified then
        vim.cmd.write()
    end

    return bufnr, file
end

local function run_terminal(args)
    vim.cmd("botright 12split")
    vim.fn.termopen(args)
    vim.cmd.startinsert()
end

function M.run()
    local _, file = current_file()
    if file then
        run_terminal({ "jbang", file })
    end
end

function M.export_native()
    local _, file = current_file()
    if file then
        run_terminal({ "jbang", "export", "native", file })
    end
end

function M.install_app()
    local _, file = current_file()
    if file then
        run_terminal({ "jbang", "app", "install", "--force", file })
    end
end

function M.sync()
    local bufnr, file = current_file()
    if not file then
        return
    end

    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        name = "jdtls",
    })

    if #clients == 0 then
        vim.notify(
            "JDTLS is not attached to this buffer",
            vim.log.levels.ERROR
        )
        return
    end

    clients[1].request(
        "workspace/executeCommand",
        {
            command = "jbang/synchronize",
            arguments = {
              { vim.uri_from_bufnr(bufnr) },
            },
        },
        function(err)
            if err then
                vim.notify(
                    "JBang synchronization failed: " .. vim.inspect(err),
                    vim.log.levels.ERROR
                )
            else
                vim.notify("JBang synchronization requested")
            end
        end,
        bufnr
    )
end

vim.api.nvim_create_user_command("JbangRun", M.run, {})
vim.api.nvim_create_user_command("JbangExportNative", M.export_native, {})
vim.api.nvim_create_user_command("JbangInstallApp", M.install_app, {})
vim.api.nvim_create_user_command("JbangSync", M.sync, {})

return M
