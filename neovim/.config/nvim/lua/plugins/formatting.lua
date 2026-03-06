-- conform.nvim: formatacao ao salvar (mais confiavel que o LSP format)
return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd   = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    go       = { "gofumpt", "goimports" },
                    lua      = { "stylua" },
                    json     = { "jq" },
                    yaml     = { "prettier" },
                    markdown = { "prettier" },
                },
                -- Formatar automaticamente ao salvar
                format_on_save = {
                    lsp_fallback = true,
                    timeout_ms   = 2000,
                },
                -- Opcoes especificas de formatters
                formatters = {
                    gofumpt = { prepend_args = { "-extra" } },
                },
            })
        end,
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                desc = "Formatar arquivo",
            },
        },
    },
}
