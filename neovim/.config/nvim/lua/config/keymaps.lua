local map = vim.keymap.set

-- ============================================================
-- NAVEGACAO ENTRE JANELAS (splits)
-- ============================================================
map("n", "<C-h>", "<C-w>h", { desc = "Janela esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Janela direita" })

-- Redimensionar splits
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Aumentar altura" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",           { desc = "Diminuir altura" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>",  { desc = "Diminuir largura" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>",  { desc = "Aumentar largura" })

-- Gerenciar splits
map("n", "<leader>sv", "<cmd>vsplit<cr>",   { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<cr>",    { desc = "Split horizontal" })
map("n", "<leader>se", "<cmd>wincmd =<cr>", { desc = "Equalizar splits" })
map("n", "<leader>sx", "<cmd>close<cr>",    { desc = "Fechar split" })

-- ============================================================
-- BUFFERS
-- ============================================================
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Proximo buffer" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer anterior" })
map("n", "<leader>bd", "<cmd>bdelete<cr>",                    { desc = "Fechar buffer" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",      { desc = "Fechar outros buffers" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>",        { desc = "Pin/unpin buffer" })

-- ============================================================
-- FILE EXPLORER
-- ============================================================
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle explorer" })
map("n", "<leader>o", "<cmd>Neotree focus<cr>",  { desc = "Focar explorer" })

-- ============================================================
-- TELESCOPE (busca)
-- ============================================================
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",              { desc = "Buscar arquivos" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",               { desc = "Buscar no codigo" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",                 { desc = "Buffers abertos" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",               { desc = "Ajuda" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",                { desc = "Arquivos recentes" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",    { desc = "Simbolos do arquivo" })
map("n", "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>",   { desc = "Simbolos do workspace" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>",             { desc = "Diagnosticos" })
map("n", "<leader>fc", "<cmd>Telescope git_commits<cr>",             { desc = "Commits git" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>",                 { desc = "Atalhos" })
map("n", "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buscar no buffer atual" })

-- ============================================================
-- EDITOR GERAL
-- ============================================================
map("n", "<leader>w", "<cmd>w<cr>",   { desc = "Salvar" })
map("n", "<leader>q", "<cmd>q<cr>",   { desc = "Sair" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Sair de tudo" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Limpar highlight de busca" })

-- Manter selecao ao indentar no visual mode
map("v", "<", "<gv", { desc = "Indentar esquerda" })
map("v", ">", ">gv", { desc = "Indentar direita" })

-- Mover linhas (Alt + j/k) - similar ao IntelliJ Shift+Alt+Up/Down
map("n", "<A-j>", "<cmd>m .+1<cr>==",  { desc = "Mover linha abaixo" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",  { desc = "Mover linha acima" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Mover linha abaixo" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Mover linha acima" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",  { desc = "Mover selecao abaixo" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",  { desc = "Mover selecao acima" })

-- Colar sem perder o registro (util no visual mode)
map("v", "p", '"_dP', { desc = "Colar sem sobrescrever registro" })

-- Ctrl+Backspace deleta palavra anterior (como no IntelliJ/qualquer editor)
-- Terminais enviam codigos diferentes para Ctrl+BS: <C-BS>, <C-H> ou ^[[127;5u
map("i", "<C-BS>", "<C-w>", { desc = "Deletar palavra anterior" })
map("i", "<C-h>", "<C-w>", { desc = "Deletar palavra anterior" })

-- Linha nova sem entrar em insert mode
map("n", "<leader>nl", "o<Esc>", { desc = "Nova linha abaixo" })
map("n", "<leader>nL", "O<Esc>", { desc = "Nova linha acima" })

-- ============================================================
-- GO ESPECIFICO
-- ============================================================
-- Snippet rapido de error handling
map("n", "<leader>goe", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>==", { desc = "Go: snippet if err" })
-- Comandos go.nvim
map("n", "<leader>gor", "<cmd>GoRun<cr>",          { desc = "Go: Rodar" })
map("n", "<leader>got", "<cmd>GoTest<cr>",          { desc = "Go: Testar (pacote)" })
map("n", "<leader>goT", "<cmd>GoTestFile<cr>",      { desc = "Go: Testar (arquivo)" })
map("n", "<leader>gof", "<cmd>GoTestFunc<cr>",      { desc = "Go: Testar (funcao)" })
map("n", "<leader>goc", "<cmd>GoCoverage<cr>",      { desc = "Go: Coverage" })
map("n", "<leader>goi", "<cmd>GoImports<cr>",       { desc = "Go: Imports" })
map("n", "<leader>gos", "<cmd>GoFillStruct<cr>",    { desc = "Go: Fill struct" })
map("n", "<leader>goat", "<cmd>GoAddTag<cr>",       { desc = "Go: Add tags" })
map("n", "<leader>gort", "<cmd>GoRmTag<cr>",        { desc = "Go: Remove tags" })

-- ============================================================
-- GIT
-- ============================================================
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- ============================================================
-- DEBUG
-- ============================================================
map("n", "<F5>",  function() require("dap").continue() end,      { desc = "Debug: Continuar" })
map("n", "<F10>", function() require("dap").step_over() end,     { desc = "Debug: Step over" })
map("n", "<F11>", function() require("dap").step_into() end,     { desc = "Debug: Step into" })
map("n", "<F12>", function() require("dap").step_out() end,      { desc = "Debug: Step out" })
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end,   { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Condicao: "))
end, { desc = "Breakpoint condicional" })
map("n", "<leader>dl", function() require("dap").run_last() end,            { desc = "Re-rodar ultimo debug" })
map("n", "<leader>dt", function() require("dap-go").debug_test() end,       { desc = "Debug test Go" })
map("n", "<leader>du", function() require("dapui").toggle() end,            { desc = "Toggle DAP UI" })
map("n", "<leader>dx", function() require("dap").terminate() end,           { desc = "Terminar debug" })
map("n", "<leader>dr", function() require("dap").repl.open() end,           { desc = "Debug REPL" })
