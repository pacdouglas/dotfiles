-- UI: statusline, bufferline, which-key, indent guides, highlights
return {
    -- ============================================================
    -- Lualine: statusline elegante
    -- ============================================================
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local function diff_source()
                local gs = vim.b.gitsigns_status_dict
                if gs then
                    return { added = gs.added, modified = gs.changed, removed = gs.removed }
                end
            end

            require("lualine").setup({
                options = {
                    theme                = "auto",
                    component_separators = { left = "|", right = "|" },
                    section_separators   = { left = "", right = "" },
                    globalstatus         = true,
                    disabled_filetypes   = { statusline = { "dashboard", "alpha", "neo-tree" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        { "diff", source = diff_source },
                        { "filename", path = 1 },
                    },
                    lualine_x = {
                        { "diagnostics", sources = { "nvim_lsp" } },
                        "encoding",
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- ============================================================
    -- Bufferline: abas de buffers no topo
    -- ============================================================
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    mode               = "buffers",
                    separator_style    = "slant",
                    always_show_bufferline = true,
                    show_buffer_close_icons = true,
                    show_close_icon    = false,
                    color_icons        = true,
                    diagnostics        = "nvim_lsp",
                custom_filter = function(buf_number)
                    if vim.fn.bufname(buf_number) == "" then return false end
                    return true
                end,
                    diagnostics_indicator = function(_, _, diag)
                        local icons = { error = " ", warning = " " }
                        local ret = (diag.error and icons.error .. diag.error .. " " or "")
                            .. (diag.warning and icons.warning .. diag.warning or "")
                        return vim.trim(ret)
                    end,
                    offsets = {
                        {
                            filetype   = "neo-tree",
                            text       = "  Explorer",
                            text_align = "left",
                            separator  = true,
                        },
                    },
                },
            })
        end,
    },

    -- ============================================================
    -- Which-key: mostra atalhos disponiveis ao pressionar leader
    -- ============================================================
    {
        "folke/which-key.nvim",
        event  = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({
                plugins = {
                    marks      = true,
                    registers  = true,
                    spelling   = { enabled = true, suggestions = 20 },
                },
                win = { border = "rounded" },
            })

            -- Registrar grupos de atalhos
            wk.add({
                { "<leader>f",   group = "Find (Telescope)" },
                { "<leader>b",   group = "Buffers" },
                { "<leader>g",   group = "Git (LazyGit)" },
                { "<leader>go",  group = "Go" },
                { "<leader>h",   group = "Git Hunks" },
                { "<leader>d",   group = "Debug" },
                { "<leader>x",   group = "Trouble / Diagnosticos" },
                { "<leader>r",   group = "Rename" },
                { "<leader>c",   group = "Code" },
                { "<leader>u",   group = "UI Toggles" },
                { "<leader>s",   group = "Splits / Swap" },
                { "<leader>t",   group = "Toggles" },
                { "<leader>n",   group = "Nova linha" },
                { "<leader>l",   group = "LSP" },
            })
        end,
    },

    -- ============================================================
    -- Indent guides: linhas verticais de indentacao
    -- ============================================================
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        main  = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "│" },
                scope  = { enabled = true },
                exclude = {
                    filetypes = { "help", "neo-tree", "dashboard", "lazy", "mason" },
                },
            })
        end,
    },

    -- ============================================================
    -- vim-illuminate: destacar todas ocorrencias da palavra sob o cursor
    -- ============================================================
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("illuminate").configure({
                providers           = { "lsp", "treesitter", "regex" },
                delay               = 200,
                filetypes_denylist  = { "neo-tree", "Trouble", "lazy", "mason" },
            })
        end,
    },

    -- ============================================================
    -- todo-comments: destacar TODO, FIXME, NOTE, HACK, WARN
    -- ============================================================
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event  = { "BufReadPost", "BufNewFile" },
        config = true,
        keys   = {
            { "]t",          function() require("todo-comments").jump_next() end, desc = "Proximo TODO" },
            { "[t",          function() require("todo-comments").jump_prev() end, desc = "TODO anterior" },
            { "<leader>ft",  "<cmd>TodoTelescope<cr>",                            desc = "Buscar TODOs" },
        },
    },

    -- ============================================================
    -- Trouble: painel de diagnosticos, referencias, quickfix
    -- ============================================================
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd  = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnosticos (workspace)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnosticos (buffer)" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix" },
            { "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>",           desc = "Referencias LSP" },
        },
    },

    -- ============================================================
    -- Noice: UI moderna para cmdline, mensagens LSP, notify
    -- ============================================================
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        config = function()
            -- Necessario quando o fundo do terminal e transparente
            require("notify").setup({ background_colour = "#000000" })

            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"]                = true,
                        ["cmp.entry.get_documentation"]                  = true,
                    },
                    progress = { enabled = false },
                },
                presets = {
                    bottom_search      = true,
                    command_palette    = true,
                    long_message_to_split = true,
                    lsp_doc_border     = true,
                },
                cmdline = { enabled = true, view = "cmdline_popup" },
                routes = {
                    -- Mensagens de escrita (ex: "12 lines written") aparecem pequenas
                    {
                        filter = {
                            event = "msg_show",
                            any   = {
                                { find = "%d+L, %d+B" },
                                { find = "; after #%d+" },
                                { find = "; before #%d+" },
                                { find = "written" },
                            },
                        },
                        view = "mini",
                    },
                },
            })
        end,
    },
}
