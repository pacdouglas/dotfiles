-- ==========================================
-- NEOVIM CONFIG 2025 - MODERN LUA SETUP (Go-first)
-- ~/.config/nvim/init.lua
-- ==========================================

-- Leader key MUST be set before plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ==========================================
-- BASIC SETTINGS
-- ==========================================

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Indentation (default). Go will override to tabs via FileType autocmd below
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true

-- UI
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Performance
opt.updatetime = 50
opt.timeoutlen = 500
opt.hidden = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Completion
opt.completeopt = { "menuone", "noselect" }
opt.pumheight = 10

-- Clipboard integration
opt.clipboard = "unnamedplus"

-- ==========================================
-- LAZY.NVIM PLUGIN MANAGER
-- ==========================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- PLUGINS
-- ==========================================

require("lazy").setup({
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					numbers = "none",
					-- Voltar para comandos mais simples
					close_command = "Bdelete! %d",
					right_mouse_command = "Bdelete! %d",
					left_trunc_marker = "<",
					right_trunc_marker = ">",
					max_name_length = 30,
					max_prefix_length = 30,
					tab_size = 21,
					show_buffer_close_icons = true,
					show_close_icon = false,
					enforce_regular_tabs = false,
					always_show_bufferline = true,
					diagnostics = "nvim_lsp",
					-- Remover offsets que podem estar causando problemas
					-- filtro para não mostrar buffers "No Name"
					custom_filter = function(buf_number, buf_numbers)
						local name = vim.api.nvim_buf_get_name(buf_number)
						-- retorna true apenas se o buffer tiver nome
						return name ~= ""
					end,
				},
			})
		end,
	},
	
	-- Plugin para melhor gerenciamento de buffers
	{
		"famiu/bufdelete.nvim",
		config = function()
			-- Este plugin fornece comandos melhores para deletar buffers
			-- sem fechar as janelas
		end,
	},

	-- Theme (kept)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},

	-- Telescope (kept)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "truncate" },
				},
			})
		end,
	},

	-- File explorer (kept)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false, -- MUDANÇA: não abrir automaticamente
				popup_border_style = "rounded",
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
			})
		end,
	},

	-- Treesitter (trimmed & Go-enabled)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"go",
					"gomod",
					"gosum",
					"gowork",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- LSP core + Mason
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "gopls", "lua_ls" },
			})

			-- Auto-install extra Go tooling (formatters, debug adapter, etc.)
			require("mason-tool-installer").setup({
				ensure_installed = {
					"gopls", -- LSP
					"gofumpt", -- formatter
					"goimports", -- imports organizer
					"delve", -- DAP
					"stylua", -- lua formatter for this config
				},
				run_on_start = true,
			})

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- gopls
			lspconfig.gopls.setup({
				capabilities = capabilities,
				settings = {
					gopls = {
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						gofumpt = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						codelenses = {
							gc_details = true,
							generate = true,
							test = true,
							tidy = true,
							vendor = true,
							upgrade_dependency = true,
						},
					},
				},
			})

			-- lua_ls (for editing this config)
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip" },
				}, {
					{ name = "path" },
					{ name = "buffer" },
				}),
			})

			-- Integrate nvim-autopairs on confirm
			local ok, cmp_autopairs = pcall(function()
				return require("nvim-autopairs.completion.cmp")
			end)
			if ok then
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
	},

	-- Formatter: Conform (Go uses gofumpt + goimports)
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				go = { "gofumpt", "goimports" },
				lua = { "stylua" },
			},
			format_on_save = function(bufnr)
				local disable_ft = {}
				if disable_ft[vim.bo[bufnr].filetype] then
					return
				end
				return { lsp_fallback = true, timeout_ms = 1500 }
			end,
		},
	},

	-- Testing: neotest + neotest-go
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({
						experimental = { test_table = true },
						args = { "-count=1", "-timeout=60s" },
					}),
				},
			})
		end,
	},

	-- Debugging: DAP core + Go adapter and UI
	{
		"mfussenegger/nvim-dap",
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = { "delve" },
			automatic_installation = true,
		},
	},
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-go").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- Statusline (kept)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{
							function()
								return vim.fn.reg_recording() ~= "" and ("REC @" .. vim.fn.reg_recording()) or ""
							end,
							color = { fg = "#f38ba8", gui = "bold" }, -- rosa Catppuccin
						},
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- Git (kept)
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- Which-key (kept)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup()
		end,
	},

	-- Autopairs (kept)
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- Comments (kept)
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- Surround (kept & lightweight)
	"tpope/vim-surround",

	-- Indent guides (kept)
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup()
		end,
	},

	-- Noice - Better UI for messages, cmdline, popups
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = true,
					lsp_doc_border = true,
				},
				cmdline = {
					enabled = true,
					view = "cmdline_popup",
				},
			})
		end,
	},
})

-- ==========================================
-- KEYMAPS
-- ==========================================

local keymap = vim.keymap.set

-- CTRL + Backspace to delete the previous word
keymap("i", "<C-H>", "<C-w>", { desc = "Delete previous word (alternative)" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
keymap("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find symbols" })
keymap("n", "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

-- Neo-tree
keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>")

-- Buffer navigation
keymap("n", "<S-l>", "<cmd>bnext<cr>")
keymap("n", "<S-h>", "<cmd>bprevious<cr>")

-- IMPORTANTE: Novos keymaps para gerenciar buffers corretamente
-- Fechar buffer sem fechar janela
keymap("n", "<leader>bd", "<cmd>Bdelete<cr>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", "<cmd>Bdelete!<cr>", { desc = "Force delete buffer" })

-- Mapear :q para fechar buffer ao invés de sair
vim.cmd([[
  " Redefinir :q para fechar buffer ao invés de sair
  cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'Bdelete' : 'q'
  cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == 'wq' ? 'w<bar>Bdelete' : 'wq'
  cnoreabbrev <expr> q! getcmdtype() == ":" && getcmdline() == 'q!' ? 'Bdelete!' : 'q!'
]])

-- Para realmente sair do Neovim, use :qa ou :quit
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
keymap("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- Clear search highlighting
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>")

-- Format file manually
keymap("n", "<leader>f", function()
	require("conform").format()
end, { desc = "Format file" })

-- Go specific shortcuts
keymap("n", "<leader>ge", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", { desc = "Go: if err != nil" })

-- Go / Tests (neotest)
keymap("n", "<leader>tn", function()
	require("neotest").run.run()
end, { desc = "Test nearest" })
keymap("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test file" })
keymap("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })
keymap("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

-- Debugging (DAP)
keymap("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "DAP: Toggle Breakpoint" })
keymap("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "DAP: Continue" })
keymap("n", "<leader>do", function()
	require("dap").step_over()
end, { desc = "DAP: Step Over" })
keymap("n", "<leader>di", function()
	require("dap").step_into()
end, { desc = "DAP: Step Into" })
keymap("n", "<leader>dr", function()
	require("dap").repl.toggle()
end, { desc = "DAP: Toggle REPL" })

-- ==========================================
-- AUTO COMMANDS
-- ==========================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.cmd([[ %s/\s\+$//e ]])
	end,
})

-- LSP keymaps + inlay hints
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		keymap("n", "gd", vim.lsp.buf.definition, opts)
		keymap("n", "K", vim.lsp.buf.hover, opts)
		keymap("n", "gi", vim.lsp.buf.implementation, opts)
		keymap("n", "gr", vim.lsp.buf.references, opts)
		keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
		keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		-- Diagnostics navigation
		keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
		keymap("n", "[d", vim.diagnostic.goto_prev, opts)
		keymap("n", "]d", vim.diagnostic.goto_next, opts)

		-- Extra useful LSP mappings
		keymap("n", "gD", vim.lsp.buf.declaration, opts)
		keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		keymap("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)

		-- Robust inlay hints enable (handles API diffs across Neovim versions)
		if vim.lsp.inlay_hint then
			local ok1, ih = pcall(function()
				return vim.lsp.inlay_hint
			end)
			if ok1 then
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.server_capabilities.inlayHintProvider then
					local success = pcall(function()
						-- Neovim 0.10+
						ih.enable(true, { bufnr = ev.buf })
					end)
					if not success then
						-- Older API shape
						pcall(ih, ev.buf, true)
					end
				end
			end
		end
	end,
})

-- Go filetype: use tabs (gofmt style)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.keymap.set("n", "]]", "/^func <CR>", { buffer = true })
		vim.keymap.set("n", "[[", "?^func <CR>", { buffer = true })
		vim.keymap.set("n", "<leader>fl", ":vimgrep /^func/j % | copen<CR>", { desc = "List functions" })
	end,
})

-- ==========================================
-- DIAGNOSTIC CONFIGURATION
-- ==========================================

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	float = {
		source = "always",
		border = "rounded",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
