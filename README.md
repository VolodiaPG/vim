# Neovim Configuration

A modern Neovim configuration using Lazy.nvim as the plugin manager, with LazyGit integration and seamless tmux navigation.

## Features

- 🚀 Fast startup time
- 📦 Lazy-loaded plugins
- 🎨 Catppuccin colorscheme
- 🔍 Telescope for fuzzy finding
- 🌳 Treesitter for syntax highlighting and code navigation
- 🧠 LSP for code intelligence
- 📝 Autocompletion with nvim-cmp
- 🔄 Git integration with Gitsigns and LazyGit
- 📊 Beautiful statusline with Staline
- 🔧 Code formatting with conform.nvim
- 🔑 Which-key for keybinding help
- 🖥️ Seamless navigation between Neovim and tmux panes
- **Harpoon**: Quick file navigation and bookmarking system
- **SuperMaven**: AI-powered coding assistant
- **LaTeX**: Full LaTeX editing and compilation support with LuaTeX and Skim
  - Enhanced syntax highlighting with Treesitter
  - Math formula concealment and highlighting
  - Color highlighting for color codes
  - Automatic spell checking for LaTeX documents

## Requirements

- Neovim >= 0.9.0
- Git
- A Nerd Font (for icons)
- ripgrep (for Telescope)
- lazygit (for LazyGit integration)
- tmux (for tmux integration)
- latexmk and texlab (for LaTeX support)
- Skim PDF viewer (for LaTeX preview on macOS)

## Installation

### Option 1: Use this repository directly

1. Make sure you have Neovim 0.9.0 or later installed
2. Install LazyGit: https://github.com/jesseduffield/lazygit#installation
3. Install tmux: https://github.com/tmux/tmux/wiki/Installing
4. Clone this repository to your Neovim config directory:

```bash
# Backup your existing config if needed
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

5. Copy the tmux configuration:

```bash
cp ~/.config/nvim/tmux.conf ~/.tmux.conf
```

6. Install the tmux plugin manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

7. Start Neovim:

```bash
nvim
```

Lazy.nvim will automatically install all plugins on the first run.

8. In tmux, press `prefix + I` (capital I) to install the tmux plugins.

### Option 2: Copy specific files

If you want to integrate parts of this configuration into your existing setup:

1. Copy the relevant files from the `lua/plugins` directory
2. Ensure your init.lua properly loads the Lazy plugin manager

## Structure

```
.
├── init.lua                 # Main entry point
├── lua
│   ├── config
│   │   ├── autocmds.lua     # Autocommands
│   │   ├── keymaps.lua      # Key mappings
│   │   └── options.lua      # Neovim options
│   └── plugins
│       ├── cmp.lua          # Completion
│       ├── colorscheme.lua  # Colorscheme
│       ├── conform.lua      # Formatter
│       ├── gitsigns.lua     # Git signs
│       ├── lazygit.lua      # LazyGit integration
│       ├── lsp.lua          # LSP configuration
│       ├── statusline.lua   # Statusline
│       ├── telescope.lua    # Fuzzy finder
│       ├── tmux.lua         # Tmux integration
│       ├── treesitter.lua   # Syntax highlighting
│       └── which-key.lua    # Keybinding help
├── tmux.conf                # Tmux configuration
└── README.md                # This file
```

## Key Mappings

### General

- `<Space>` - Leader key
- `<Esc>` - Clear search highlights
- `<C-h/j/k/l>` - Navigate between splits (works with tmux)
- `<C-Up/Down/Left/Right>` - Resize windows
- `<C-s>` - Save file
- `<leader>q` - Quit
- `<leader>Q` - Force quit all

### Telescope

- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Recent files

### LSP

- `gd` - Go to definition
- `gr` - Go to references
- `K` - Hover documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `<leader>cf` - Format buffer

### Git

- `<leader>gg` - Open LazyGit
- `<leader>gs` - Stage hunk
- `<leader>gr` - Reset hunk
- `<leader>gp` - Preview hunk
- `<leader>gb` - Blame line

### Harpoon

- `<leader>hs` - Add current file to Harpoon
- `<leader>hd` - Toggle Harpoon quick menu
- `<leader>hp` - Navigate to previous Harpoon file
- `<leader>hn` - Navigate to next Harpoon file
- `&` - Navigate to Harpoon file 1
- `é` - Navigate to Harpoon file 2
- `"` - Navigate to Harpoon file 3
- `'` - Navigate to Harpoon file 4
- `(` - Navigate to Harpoon file 5
- `-` - Navigate to Harpoon file 6
- `è` - Navigate to Harpoon file 7
- `_` - Navigate to Harpoon file 8
- `ç` - Navigate to Harpoon file 9

### LaTeX

- `<leader>tc` - Compile LaTeX document
- `<leader>tv` - View PDF
- `<leader>tt` - Toggle table of contents
- `<leader>te` - Show compilation errors
- `<leader>ts` - Stop compilation
- `<leader>tS` - Stop all compilations
- `<leader>ti` - Show document info
- `<leader>tI` - Show detailed document info
- `<leader>tl` - Show compilation log
- `<leader>tL` - Clean auxiliary files
- `<leader>tk` - Show package documentation
- `<leader>tK` - Count words in document
- `<leader>tx` - Reload VimTeX

### Tmux

- `<C-h/j/k/l>` - Navigate between Neovim splits and tmux panes
- `<C-a>c` - Create a new tmux window
- `<C-a>%` - Split pane vertically
- `<C-a>"` - Split pane horizontally
- `<C-a>z` - Zoom pane
- `<C-a>[` - Enter copy mode

## Using LazyGit

LazyGit is a terminal UI for git commands. To use it:

1. Press `<leader>gg` to open LazyGit
2. Navigate through the UI using the keyboard:
   - `?` - Show help
   - Arrow keys to navigate
   - `Enter` to select
   - `q` to quit

## Tmux Integration

This configuration includes seamless navigation between Neovim splits and tmux panes using the same keybindings:

- `Ctrl-h` - Move to the left split/pane
- `Ctrl-j` - Move to the bottom split/pane
- `Ctrl-k` - Move to the top split/pane
- `Ctrl-l` - Move to the right split/pane

### Tmux Keybindings

- `Ctrl-a` - Prefix key
- `Prefix + |` - Split horizontally
- `Prefix + -` - Split vertically
- `Prefix + h/j/k/l` - Navigate between panes
- `Prefix + H/J/K/L` - Resize panes
- `Prefix + r` - Reload tmux configuration
- `Prefix + I` - Install tmux plugins

## Customization

You can customize this configuration by editing the files in the `lua/config` and `lua/plugins` directories.

### Adding New Plugins

To add a new plugin, create a new file in the `lua/plugins` directory with the plugin configuration.

Example:

```lua
-- lua/plugins/newplugin.lua
return {
  "username/newplugin",
  config = function()
    require("newplugin").setup({
      -- options here
    })
  end,
}
```

## License

MIT 