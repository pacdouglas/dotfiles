-- Treesitter: syntax highlighting rico e text objects poderosos
-- API v1: nvim-treesitter mudou completamente — highlight/indent agora sao built-in do Neovim
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            -- Instala parsers que faltam automaticamente
            local ensure_installed = {
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
            }

            -- Verifica quais parsers faltam e instala
            local installed = require("nvim-treesitter").installed()
            local to_install = {}
            for _, lang in ipairs(ensure_installed) do
                if not vim.tbl_contains(installed, lang) then
                    table.insert(to_install, lang)
                end
            end
            if #to_install > 0 then
                require("nvim-treesitter").install(to_install)
            end

            -- Textobjects: config separada na v1
            require("nvim-treesitter-textobjects").setup({
                select = {
                    enable = true,
                    lookahead = true,
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
                swap = {
                    enable = true,
                    swap_next     = { ["<leader>sp"] = "@parameter.inner" },
                    swap_previous = { ["<leader>sP"] = "@parameter.inner" },
                },
            })
        end,
    },
}
