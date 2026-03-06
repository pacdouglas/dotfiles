-- Neo-tree: explorador de arquivos moderno
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            -- Remover o netrw legado
            vim.g.loaded_netrw       = 1
            vim.g.loaded_netrwPlugin = 1

            require("neo-tree").setup({
                close_if_last_window   = true,
                popup_border_style     = "rounded",
                enable_git_status      = true,
                enable_diagnostics     = true,
                open_files_do_not_replace_types = { "terminal", "trouble", "qf" },

                filesystem = {
                    filtered_items = {
                        hide_dotfiles   = false,
                        hide_gitignored = false,
                        hide_by_name    = { ".DS_Store", "thumbs.db" },
                    },
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                },

                window = {
                    width = 35,
                    mappings = {
                        ["<space>"] = "none",  -- nao conflitar com leader
                        ["l"]       = "open",
                        ["h"]       = "close_node",
                        ["H"]       = "toggle_hidden",
                    },
                },

                default_component_configs = {
                    indent = {
                        with_expanders  = true,
                        expander_collapsed = "",
                        expander_expanded  = "",
                    },
                    git_status = {
                        symbols = {
                            added     = "",
                            modified  = "",
                            deleted   = "✖",
                            renamed   = "󰁕",
                            untracked = "",
                            ignored   = "",
                            unstaged  = "󰄱",
                            staged    = "",
                            conflict  = "",
                        },
                    },
                },
            })
        end,
    },
}
