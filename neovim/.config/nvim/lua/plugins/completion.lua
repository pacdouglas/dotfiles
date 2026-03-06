-- blink.cmp: autocompletion moderno (2025), escrito em Rust, muito mais rapido que nvim-cmp
return {
    {
        "saghen/blink.cmp",
        lazy = false,
        version = "1.*",    -- usa binarios pre-compilados, sem precisar de Rust instalado
        dependencies = {
            "rafamadriz/friendly-snippets",   -- snippets prontos (Go, Lua, etc.)
        },
        opts = {
            -- Teclas de autocompletion
            keymap = {
                preset = "default",
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"]     = { "hide", "fallback" },
                ["<CR>"]      = { "accept", "fallback" },
                ["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
                ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
                ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },

            -- Fontes de completion
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            completion = {
                -- Documentacao automatica ao selecionar item
                documentation = {
                    auto_show          = true,
                    auto_show_delay_ms = 200,
                    window = { border = "rounded" },
                },
                -- Menu de completion
                menu = {
                    border = "rounded",
                    draw = {
                        treesitter = { "lsp" },
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind" },
                        },
                    },
                },
                -- Ghost text: previa do completion inline (como o Copilot)
                ghost_text = { enabled = true },
            },

            -- Signature help automatico
            signature = {
                enabled = true,
                window  = { border = "rounded" },
            },
        },
    },
}
