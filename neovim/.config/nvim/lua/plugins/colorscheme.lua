-- Temas instalados (todos com suporte a transparencia)
-- Para trocar: mude o vim.cmd.colorscheme() la embaixo
return {
    { "rose-pine/neovim",             name = "rose-pine",   lazy = true },
    { "folke/tokyonight.nvim",        lazy = true },
    { "catppuccin/nvim",              name = "catppuccin",  lazy = true },
    { "rebelot/kanagawa.nvim",        lazy = true },
    { "EdenEast/nightfox.nvim",       lazy = true },
    { "sainnhe/gruvbox-material",     lazy = true },

    -- Tema ATIVO (mude aqui para trocar)
    {
        "folke/tokyonight.nvim",
        name     = "tokyonight-active",
        lazy     = false,
        priority = 1000,
        config   = function()
            require("tokyonight").setup({
                style       = "night",   -- feito para fundos escuros/pretos, alto contraste
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    floats   = "transparent",
                },
                -- Garantir que comentarios nao fiquem muito apagados no fundo preto
                on_highlights = function(hl, _)
                    hl.Comment = { fg = "#6a7891", italic = true }
                end,
            })
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    -- CATPPUCCIN (cores fortes mas fica acinzentado em fundo preto)
    -- { "catppuccin/nvim", name = "catppuccin-active", lazy = false, priority = 1000,
    --   config = function()
    --     require("catppuccin").setup({ flavour = "mocha", transparent_background = true })
    --     vim.cmd.colorscheme("catppuccin-mocha")
    --   end },

    -- ROSE PINE (quente: roses, golds, teals)
    -- { "rose-pine/neovim", name = "rose-pine-active", lazy = false, priority = 1000,
    --   config = function()
    --     require("rose-pine").setup({ variant = "main", styles = { transparency = true } })
    --     vim.cmd.colorscheme("rose-pine")
    --   end },

    -- KANAGAWA
    -- { "rebelot/kanagawa.nvim", name = "kanagawa-active", lazy = false, priority = 1000,
    --   config = function()
    --     require("kanagawa").setup({ transparent = true, theme = "wave" })
    --     vim.cmd.colorscheme("kanagawa")
    --   end },

    -- GRUVBOX MATERIAL (laranja/amarelo quente, proximo ao Darcula)
    -- { "sainnhe/gruvbox-material", name = "gruvbox-active", lazy = false, priority = 1000,
    --   config = function()
    --     vim.g.gruvbox_material_background = "hard"
    --     vim.g.gruvbox_material_transparent_background = 2
    --     vim.cmd.colorscheme("gruvbox-material")
    --   end },
}
