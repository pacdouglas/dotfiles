-- Treesitter: syntax highlighting rico e text objects poderosos
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            -- Text objects baseados em sintaxe (funcoes, parametros, blocos)
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
        opts = {
                ensure_installed = {
                    -- Go
                    "go", "gomod", "gosum", "gowork",
                    -- Kotlin
                    "kotlin",
                    -- Lua (config do nvim)
                    "lua", "vim", "vimdoc", "query",
                    -- Formatos comuns
                    "json", "yaml", "toml",
                    "markdown", "markdown_inline",
                    "bash", "dockerfile", "sql", "regex",
                },
                sync_install = false,
                auto_install = true,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                indent = { enable = true },

                -- Text objects: selecionar funcoes, parametros, blocos
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,   -- vai ao proximo se nao estiver em cima
                        keymaps = {
                            ["af"] = { query = "@function.outer", desc = "funcao externa" },
                            ["if"] = { query = "@function.inner", desc = "funcao interna" },
                            ["ac"] = { query = "@class.outer",    desc = "struct/class externa" },
                            ["ic"] = { query = "@class.inner",    desc = "struct/class interna" },
                            ["aa"] = { query = "@parameter.outer", desc = "argumento externo" },
                            ["ia"] = { query = "@parameter.inner", desc = "argumento interno" },
                            ["ab"] = { query = "@block.outer",    desc = "bloco externo" },
                            ["ib"] = { query = "@block.inner",    desc = "bloco interno" },
                        },
                    },
                    -- Navegar entre funcoes/structs com ]f [f ]c [c
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = { query = "@function.outer", desc = "Proxima funcao" },
                            ["]c"] = { query = "@class.outer",    desc = "Proxima struct" },
                        },
                        goto_next_end = {
                            ["]F"] = { query = "@function.outer", desc = "Fim proxima funcao" },
                            ["]C"] = { query = "@class.outer",    desc = "Fim proxima struct" },
                        },
                        goto_previous_start = {
                            ["[f"] = { query = "@function.outer", desc = "Funcao anterior" },
                            ["[c"] = { query = "@class.outer",    desc = "Struct anterior" },
                        },
                        goto_previous_end = {
                            ["[F"] = { query = "@function.outer", desc = "Fim funcao anterior" },
                            ["[C"] = { query = "@class.outer",    desc = "Fim struct anterior" },
                        },
                    },
                    -- Trocar parametros de lugar
                    swap = {
                        enable = true,
                        swap_next     = { ["<leader>sp"] = "@parameter.inner" },
                        swap_previous = { ["<leader>sP"] = "@parameter.inner" },
                    },
                },
        },
    },
}
