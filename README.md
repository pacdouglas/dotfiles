# dotfiles

> Config files I destroy and rebuild every week convinced that this time it'll be perfect.

## What is this?

My configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).
The concept is simple: each folder here becomes a magic symlink into your `$HOME`,
as if the universe placed the files there, but it's actually just an illusion.

Philosophically speaking, it's exactly like life.

## How to use

```bash
git clone https://github.com/pac/dotfiles ~/dotfiles
cd ~/dotfiles

# Install everything at once
stow neovim tmux kitty zshrc starship git

# Or just what you want to steal (choose wisely)
stow neovim
```

## What's in here

| Folder | What it does |
|--------|--------------|
| `neovim` | Neovim with modular config. Took hours. Works (sometimes). |
| `tmux` | Terminal multiplexer to look like a hacker on video calls |
| `kitty` | Pretty terminal with transparency to show off the wallpaper you never look at |
| `zshrc` | ZSH with aliases I always forget exist |
| `starship` | Colorful prompt to compensate for the lack of color in life |
| `git` | Git configs. Split by work/personal so I don't commit to the wrong repo at 11pm |
| `ssh` | SSH config. Nothing interesting here, move along |
| `hyprland` | Wayland compositor. When it works, it's beautiful. When it doesn't, it's Monday |
| `waybar` | Status bar. Hidden 90% of the time, shown to someone 10% of the time |
| `wofi` | App launcher. Like Spotlight, but you need to know the app name |
| `idea` | IdeaVim for IntelliJ. Pretending to use Vim while running a 2GB IDE |
| `vim` | Legacy `.vimrc`. Kept for historical and sentimental reasons |

## Neovim

Built from scratch focused on **Go** development.
Modular structure, one file per responsibility — no 500-line `init.lua`
that nobody understands, not even the author three days later.

Features:
- Native LSP (Neovim 0.11+)
- Debug with DAP (real breakpoints, not just shameful `fmt.Println`)
- Fast completion with blink.cmp
- Fuzzy find with Telescope
- Git with LazyGit
- catppuccin-mocha theme with transparent background

There's even a Vim guide at [`VIM_GUIDE.md`](./VIM_GUIDE.md) for those who want to learn
to edit text in a way that makes coworkers think you're having an episode.

## Requirements

- `git` (you probably already have this)
- `stow` (`apt install stow` / `brew install stow`)
- `nvim >= 0.11`
- `go` (if you want to actually use the Neovim setup)
- `delve` (Go debugger — `go install github.com/go-delve/delve/cmd/dlv@latest`)
- Infinite patience with terminal configuration

## Disclaimer

These dotfiles work on my machine.
On yours, they might work, might not, or might open a dimensional portal.
No warranties. Use at your own risk.

---

*"Dotfiles are like bonsai trees: you spend years trimming them, they're never finished,
but the process is therapeutic."*
