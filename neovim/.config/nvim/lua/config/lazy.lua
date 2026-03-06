local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Falha ao instalar lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPressione qualquer tecla para sair..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    -- Detectar mudancas nos arquivos de plugin automaticamente
    change_detection = { notify = false },
    -- Verificar atualizacoes (sem notificacoes ruidosas)
    checker = { enabled = true, notify = false },
    ui = {
        border = "rounded",
    },
    performance = {
        rtp = {
            -- Desabilitar plugins nativos que nao usamos
            disabled_plugins = {
                "gzip", "matchit", "matchparen",
                "netrwPlugin", "tarPlugin", "tohtml",
                "tutor", "zipPlugin",
            },
        },
    },
})
