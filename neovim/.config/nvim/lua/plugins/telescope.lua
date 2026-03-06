-- Telescope: fuzzy finder para arquivos, buffers, grep, LSP, git, etc.
return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- fzf nativo: muito mais rapido para arquivos grandes
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            local actions   = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix   = "  ",
                    selection_caret = " ",
                    path_display    = { "truncate" },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width   = 0.55,
                        },
                        width  = 0.87,
                        height = 0.80,
                    },
                    mappings = {
                        i = {
                            ["<C-j>"]  = actions.move_selection_next,
                            ["<C-k>"]  = actions.move_selection_previous,
                            ["<C-q>"]  = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<Esc>"]  = actions.close,
                            ["<C-u>"]  = false,  -- limpar com C-u (padrao do readline)
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        -- Ignorar node_modules, .git, binarios
                        find_command = { "rg", "--files", "--hidden", "--glob", "!{.git,node_modules,vendor}/*" },
                    },
                    live_grep = {
                        additional_args = { "--hidden", "--glob", "!{.git,node_modules,vendor}/*" },
                    },
                    buffers = {
                        sort_mru = true,   -- mais recentes primeiro
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy                   = true,
                        override_generic_sorter = true,
                        override_file_sorter    = true,
                        case_mode               = "smart_case",
                    },
                },
            })

            telescope.load_extension("fzf")
        end,
    },
}
