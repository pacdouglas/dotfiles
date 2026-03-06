-- Git: gitsigns (sinais no gutter) + lazygit (UI completa)
return {
    -- Sinais de git na coluna de numeros (added/changed/deleted)
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "▎" },
                    change       = { text = "▎" },
                    delete       = { text = "" },
                    topdelete    = { text = "" },
                    changedelete = { text = "▎" },
                    untracked    = { text = "▎" },
                },

                on_attach = function(bufnr)
                    local gs  = package.loaded.gitsigns
                    local map = function(mode, l, r, opts)
                        opts        = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navegar entre hunks
                    map("n", "]h", gs.next_hunk, { desc = "Proximo hunk" })
                    map("n", "[h", gs.prev_hunk, { desc = "Hunk anterior" })

                    -- Acoes em hunks
                    map("n", "<leader>hs", gs.stage_hunk,  { desc = "Stage hunk" })
                    map("n", "<leader>hr", gs.reset_hunk,  { desc = "Reset hunk" })
                    map("v", "<leader>hs", function()
                        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Stage hunk (selecao)" })
                    map("v", "<leader>hr", function()
                        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Reset hunk (selecao)" })
                    map("n", "<leader>hS", gs.stage_buffer,      { desc = "Stage buffer inteiro" })
                    map("n", "<leader>hu", gs.undo_stage_hunk,   { desc = "Undo stage hunk" })
                    map("n", "<leader>hR", gs.reset_buffer,      { desc = "Reset buffer" })
                    map("n", "<leader>hp", gs.preview_hunk,      { desc = "Preview hunk" })
                    map("n", "<leader>hb", function()
                        gs.blame_line({ full = true })
                    end, { desc = "Blame linha completo" })
                    map("n", "<leader>hd", gs.diffthis,          { desc = "Diff com index" })
                    map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame inline" })
                    map("n", "<leader>td", gs.toggle_deleted,    { desc = "Toggle deletados" })
                end,
            })
        end,
    },

    -- LazyGit: interface visual completa (commit, push, rebase, etc.)
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = {
            "LazyGit", "LazyGitConfig", "LazyGitCurrentFile",
            "LazyGitFilter", "LazyGitFilterCurrentFile",
        },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
}
