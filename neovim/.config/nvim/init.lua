-- Leader key DEVE ser definido antes de tudo
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")
