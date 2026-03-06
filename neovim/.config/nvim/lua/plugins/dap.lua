-- DAP: Debug Adapter Protocol
-- nvim-dap = core | nvim-dap-go = adapter Go | nvim-dap-ui = interface visual
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- Interface visual para debug (variaveis, stack, watches, console)
            { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
            -- Adapter especifico para Go (usa delve)
            "leoluz/nvim-dap-go",
        },
        config = function()
            local dap    = require("dap")
            local dapui  = require("dapui")

            -- --------------------------------------------------------
            -- Adapter Go (delve)
            -- --------------------------------------------------------
            require("dap-go").setup({
                dap_configurations = {
                    {
                        type    = "go",
                        name    = "Debug: arquivo atual",
                        request = "launch",
                        program = "${file}",
                    },
                    {
                        type    = "go",
                        name    = "Debug: pacote atual",
                        request = "launch",
                        program = "${fileDirname}",
                    },
                    {
                        type    = "go",
                        name    = "Debug: com argumentos",
                        request = "launch",
                        program = "${fileDirname}",
                        args    = function()
                            local args = vim.fn.input("Argumentos: ")
                            return vim.split(args, " ")
                        end,
                    },
                    {
                        type      = "go",
                        name      = "Debug test: arquivo",
                        request   = "launch",
                        mode      = "test",
                        program   = "${file}",
                    },
                    {
                        type      = "go",
                        name      = "Debug test: pacote",
                        request   = "launch",
                        mode      = "test",
                        program   = "${fileDirname}",
                    },
                    {
                        type      = "go",
                        name      = "Attach: processo local",
                        request   = "attach",
                        processId = require("dap.utils").pick_process,
                    },
                },
            })

            -- --------------------------------------------------------
            -- DAP UI: interface visual
            -- --------------------------------------------------------
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▶" },
                layouts = {
                    {
                        -- Painel lateral: variaveis, breakpoints, stack, watches
                        elements = {
                            { id = "scopes",      size = 0.30 },
                            { id = "breakpoints", size = 0.15 },
                            { id = "stacks",      size = 0.30 },
                            { id = "watches",     size = 0.25 },
                        },
                        size     = 45,
                        position = "left",
                    },
                    {
                        -- Painel inferior: REPL + console de output
                        elements = {
                            { id = "repl",    size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size     = 12,
                        position = "bottom",
                    },
                },
                floating = {
                    border   = "rounded",
                    mappings = { close = { "q", "<Esc>" } },
                },
            })

            -- Abrir/fechar DAP UI automaticamente com a sessao de debug
            dap.listeners.after.event_initialized["dapui_config"]  = dapui.open
            dap.listeners.before.event_terminated["dapui_config"]  = dapui.close
            dap.listeners.before.event_exited["dapui_config"]      = dapui.close

            -- --------------------------------------------------------
            -- Sinais visuais (breakpoints, cursor de debug)
            -- --------------------------------------------------------
            vim.fn.sign_define("DapBreakpoint",          { text = "🔴", texthl = "DiagnosticError" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DiagnosticWarn" })
            vim.fn.sign_define("DapLogPoint",            { text = "🔵", texthl = "DiagnosticInfo" })
            vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticWarn", linehl = "DapStoppedLine" })
            vim.fn.sign_define("DapBreakpointRejected",  { text = "❌", texthl = "DiagnosticError" })
        end,
    },
}
