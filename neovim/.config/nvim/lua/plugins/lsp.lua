-- LSP: Language Server Protocol
-- Usa a API nativa do Neovim 0.11+ (vim.lsp.config / vim.lsp.enable)
-- Mason instala os binarios automaticamente
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",   -- para obter capabilities
        },
        config = function()
            -- Mason: gerenciador de binarios (LSPs, linters, formatters)
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed   = "✓",
                        package_pending     = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = { "gopls", "lua_ls", "kotlin_language_server" },
                automatic_installation = true,
            })

            -- Capabilities estendidas pelo blink.cmp (autocompletion)
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- --------------------------------------------------------
            -- gopls: Language Server oficial do Go
            -- --------------------------------------------------------
            vim.lsp.config.gopls = {
                cmd        = { "gopls" },
                filetypes  = { "go", "gomod", "gowork", "gotmpl" },
                root_markers = { "go.work", "go.mod", ".git" },
                capabilities = capabilities,
                settings = {
                    gopls = {
                        -- Completions
                        usePlaceholders    = true,
                        completeUnimported = true,
                        -- Analise estatica
                        staticcheck = true,
                        gofumpt     = true,
                        analyses = {
                            unusedparams = true,
                            unreachable  = true,
                            shadow       = true,
                            nilness      = true,
                            useany       = true,
                        },
                        -- Inlay hints (tipos inferidos, nomes de params)
                        hints = {
                            assignVariableTypes    = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes  = true,
                            constantValues         = true,
                            functionTypeParameters = true,
                            parameterNames         = true,
                            rangeVariableTypes     = true,
                        },
                        -- Code lenses (Run test | Debug test sobre cada funcao)
                        codelenses = {
                            gc_details          = true,
                            generate            = true,
                            run_govulncheck     = true,
                            test                = true,
                            tidy                = true,
                            upgrade_dependency  = true,
                        },
                    },
                },
            }
            vim.lsp.enable("gopls")

            -- --------------------------------------------------------
            -- lua_ls: Language Server para Lua (config do nvim)
            -- --------------------------------------------------------
            vim.lsp.config.lua_ls = {
                cmd       = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git" },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = { enable = false },
                        format    = { enable = false },   -- deixa para stylua
                    },
                },
            }
            vim.lsp.enable("lua_ls")

            -- --------------------------------------------------------
            -- kotlin_language_server: Language Server para Kotlin
            -- --------------------------------------------------------
            vim.lsp.config.kotlin_language_server = {
                cmd       = { "kotlin-language-server" },
                filetypes = { "kotlin" },
                root_markers = { "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", "pom.xml", ".git" },
                capabilities = capabilities,
                settings = {
                    kotlin = {
                        compiler = { jvm = { target = "17" } },
                        hints = {
                            typeHints    = true,
                            parameterHints = true,
                            chainingHints  = true,
                        },
                    },
                },
            }
            vim.lsp.enable("kotlin_language_server")

            -- --------------------------------------------------------
            -- Diagnosticos: visual e comportamento
            -- --------------------------------------------------------
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    source = "if_many",
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort    = true,
                float = {
                    border = "rounded",
                    source = true,
                },
            })

            -- Icones nos diagnosticos
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- --------------------------------------------------------
            -- Keymaps do LSP (ativados ao anexar o servidor ao buffer)
            -- --------------------------------------------------------
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }
                    local map  = vim.keymap.set

                    -- Navegacao
                    map("n", "gd",  vim.lsp.buf.definition,      vim.tbl_extend("force", opts, { desc = "Ir para definicao" }))
                    map("n", "gD",  vim.lsp.buf.declaration,     vim.tbl_extend("force", opts, { desc = "Ir para declaracao" }))
                    map("n", "gr",  vim.lsp.buf.references,      vim.tbl_extend("force", opts, { desc = "Ver referencias" }))
                    map("n", "gi",  vim.lsp.buf.implementation,  vim.tbl_extend("force", opts, { desc = "Ir para implementacao" }))
                    map("n", "gt",  vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Ir para tipo" }))

                    -- Documentacao
                    map("n", "K",    vim.lsp.buf.hover,           vim.tbl_extend("force", opts, { desc = "Documentacao (hover)" }))
                    map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

                    -- Refactoring
                    map("n",      "<leader>rn", vim.lsp.buf.rename,      vim.tbl_extend("force", opts, { desc = "Renomear simbolo" }))
                    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))

                    -- Diagnosticos
                    map("n", "<leader>d", vim.diagnostic.open_float,   vim.tbl_extend("force", opts, { desc = "Diagnostico flutuante" }))
                    map("n", "[d",        vim.diagnostic.goto_prev,     vim.tbl_extend("force", opts, { desc = "Diagnostico anterior" }))
                    map("n", "]d",        vim.diagnostic.goto_next,     vim.tbl_extend("force", opts, { desc = "Proximo diagnostico" }))

                    -- Info
                    map("n", "<leader>li", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "LSP info" }))

                    -- Inlay hints (Neovim 0.10+): mostrar tipos inferidos inline
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if client and client.supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                        map("n", "<leader>uh", function()
                            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
                            vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
                        end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
                    end
                end,
            })
        end,
    },
}
