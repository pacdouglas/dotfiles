local opt = vim.opt

-- Numeros de linha
opt.number = true
opt.relativenumber = true

-- Indentacao
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Busca
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Visual
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.showmode = false      -- lualine ja mostra o modo
opt.laststatus = 3        -- statusline global unica

-- Comportamento
opt.hidden = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.updatetime = 100
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.splitright = true
opt.splitbelow = true
opt.fileencoding = "utf-8"

-- Folds via treesitter
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99
