# CLAUDE.md — Dotfiles de pac

## Visao Geral

Repositorio de dotfiles gerenciado com **GNU Stow**.
Cada pasta raiz = nome da aplicacao. A estrutura interna espelha `$HOME`.

```
stow neovim   # cria symlink: ~/.config/nvim -> dotfiles/neovim/.config/nvim
stow tmux     # cria symlink: ~/.tmux.conf   -> dotfiles/tmux/.tmux.conf
```

## Estrutura

```
dotfiles/
├── neovim/.config/nvim/     # Neovim
├── tmux/                    # Tmux
├── kitty/.config/kitty/     # Kitty terminal
├── zshrc/.zshrc             # ZSH
├── starship/.config/        # Starship prompt
├── git/                     # Git configs (personal + work)
├── ssh/.ssh/config          # SSH
├── hyprland/                # Hyprland WM
├── waybar/                  # Waybar
├── wofi/                    # Wofi launcher
├── vim/.vimrc               # Vim legado
├── idea/.ideavimrc          # IdeaVim (IntelliJ)
├── VIM_GUIDE.md             # Guia completo de Vim (pode imprimir)
└── CLAUDE.md                # Este arquivo
```

## Neovim

Config modular em `neovim/.config/nvim/`:

```
init.lua                  # entry point (leader, carrega config.*)
lua/config/
  options.lua             # vim.opt
  autocmds.lua            # autocomandos
  keymaps.lua             # atalhos globais
  lazy.lua                # bootstrap lazy.nvim
lua/plugins/
  colorscheme.lua         # tema ativo: catppuccin-mocha (transparente)
  treesitter.lua          # syntax highlighting + text objects
  lsp.lua                 # gopls + lua_ls (API nativa vim.lsp.config)
  completion.lua          # blink.cmp v1.*
  telescope.lua           # fuzzy finder (treesitter preview desabilitado: nvim 0.11)
  explorer.lua            # neo-tree v3
  git.lua                 # gitsigns + lazygit
  go.lua                  # go.nvim (GoTest, GoRun, FillStruct, etc.)
  dap.lua                 # nvim-dap + nvim-dap-go + nvim-dap-ui
  formatting.lua          # conform.nvim (gofumpt + goimports, auto on save)
  ui.lua                  # lualine, bufferline, which-key, noice, trouble, etc.
  editor.lua              # autopairs, mini.surround, comment, spectre
```

### Decisoes tecnicas importantes

- **Plugin manager**: lazy.nvim (lazy loading por evento/filetype)
- **LSP API**: `vim.lsp.config` + `vim.lsp.enable` (nativa Neovim 0.11+, sem lspconfig.setup())
- **Completion**: blink.cmp (nao nvim-cmp) — mais rapido, binario Rust pre-compilado
- **Tema**: tokyonight-night com `transparent_background = true` (catppuccin, rose-pine, kanagawa, gruvbox-material disponíveis)
- **Telescope**: `preview.treesitter = false` — fix de incompatibilidade com Neovim 0.11
- **Treesitter**: usa `require("nvim-treesitter").setup()` (API v1, nao `nvim-treesitter.configs`)
- **Formatacao**: conform.nvim formata ao salvar (gofumpt + goimports para Go)
- **Leader**: `<Space>`

### Trocar tema

Editar `lua/plugins/colorscheme.lua`: descomentar o bloco desejado e comentar o ativo.
Temas instalados: catppuccin, tokyonight, rose-pine, kanagawa, nightfox, gruvbox-material.

### LSPs gerenciados pelo Mason

```
:MasonInstall gopls lua-language-server delve gofumpt
```

## Convencoes

- Comentarios em portugues
- Um arquivo por dominio em `lua/plugins/`
- Keymaps de plugins ficam no proprio arquivo do plugin (via `keys = {}`)
- Keymaps globais ficam em `lua/config/keymaps.lua`
- Nao usar `require("lspconfig").X.setup()` — usar `vim.lsp.config` + `vim.lsp.enable`

## Ambiente

- OS: WSL2 (Linux)
- Shell: zsh
- Terminal: Kitty (com transparencia ativa)
- Neovim: 0.11.x
