-- go.nvim: plugin dedicado ao Go com funcionalidades que o gopls nao cobre
-- FillStruct, AddTag, TestFunc, Coverage, Run, etc.
return {
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        ft      = { "go", "gomod", "gowork", "gotmpl" },
        build   = ':lua require("go.install").update_all_sync()',
        config  = function()
            require("go").setup({
                -- LSP e diagnostics gerenciados por lsp.lua
                lsp_cfg        = false,
                lsp_on_attach  = false,
                diagnostic     = false,

                -- Formatter
                lsp_gofumpt = true,
                gofmt       = "gofumpt",
                goimports   = "gopls",

                -- Runner e testes
                go          = "go",
                test_runner = "go",
                run_in_floaterm = false,

                -- Mostrar icons no debug
                icons = { breakpoint = "🔴", currentpos = "▶" },

                -- Inlay hints gerenciados por lsp.lua
                lsp_inlay_hints = { enable = false },

                -- Nao poluir com logs
                verbose = false,
                log_path = vim.fn.expand("$HOME") .. "/.cache/nvim/gonvim.log",
            })
        end,
    },
}
