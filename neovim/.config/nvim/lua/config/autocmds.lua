local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight ao copiar (yank)
autocmd("TextYankPost", {
    group = augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Remove trailing whitespace ao salvar
autocmd("BufWritePre", {
    group = augroup("trim_whitespace", { clear = true }),
    callback = function()
        vim.cmd([[ %s/\s\+$//e ]])
    end,
})

-- Go: usa tabs (padrao Go), nao espacos
autocmd("FileType", {
    group = augroup("go_indent", { clear = true }),
    pattern = "go",
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

-- Fechar janelas utilitarias com 'q'
autocmd("FileType", {
    group = augroup("close_with_q", { clear = true }),
    pattern = { "help", "lspinfo", "man", "notify", "qf", "checkhealth", "startuptime" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Redimensionar splits ao redimensionar janela do terminal
autocmd("VimResized", {
    group = augroup("resize_splits", { clear = true }),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- Voltar para ultima posicao do cursor ao abrir arquivo
autocmd("BufReadPost", {
    group = augroup("last_cursor_position", { clear = true }),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) then return end
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
