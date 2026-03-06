-- Editor: utilidades de edicao do dia a dia
return {
    -- Auto fechamento de pares: () [] {} "" ''
    {
        "windwp/nvim-autopairs",
        event  = "InsertEnter",
        config = true,
    },

    -- mini.surround: adicionar/remover/trocar "delimitadores" ao redor de texto
    -- gsa" -> adicionar aspas | gsd" -> remover aspas | gsr"' -> trocar " por '
    {
        "echasnovski/mini.surround",
        version = "*",
        config  = function()
            require("mini.surround").setup({
                mappings = {
                    add            = "gsa",   -- gsa" = adicionar aspas ao redor
                    delete         = "gsd",   -- gsd" = deletar aspas ao redor
                    find           = "gsf",
                    find_left      = "gsF",
                    highlight      = "gsh",
                    replace        = "gsr",   -- gsr"' = trocar " por '
                    update_n_lines = "gsn",
                },
            })
        end,
    },

    -- Comentarios: gcc = linha | gc + motion = range | gcap = paragrafo
    {
        "numToStr/Comment.nvim",
        event  = { "BufReadPost", "BufNewFile" },
        config = true,
    },

    -- mini.move: mover linhas/selecoes com Alt+hjkl
    -- (os keymaps de <A-j>/<A-k> em keymaps.lua cobrem o caso mais comum)
    {
        "echasnovski/mini.move",
        version = "*",
        config  = function()
            require("mini.move").setup({
                mappings = {
                    left       = "<M-h>",
                    right      = "<M-l>",
                    down       = "<M-j>",
                    up         = "<M-k>",
                    line_left  = "<M-h>",
                    line_right = "<M-l>",
                    line_down  = "<M-j>",
                    line_up    = "<M-k>",
                },
            })
        end,
    },

    -- nvim-spectre: find & replace global com regex (como o Replace in Files do JetBrains)
    {
        "nvim-pack/nvim-spectre",
        build  = false,
        cmd    = "Spectre",
        keys   = {
            { "<leader>sr",  function() require("spectre").open() end,                      desc = "Search & Replace (global)" },
            { "<leader>sw",  function() require("spectre").open_visual({ select_word = true }) end, desc = "Buscar palavra atual" },
        },
    },
}
