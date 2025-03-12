# Migrating from Nix to Lazy.nvim

This document provides guidance on migrating from a Nix-based Neovim configuration to this Lazy.nvim-based configuration.

## Why Migrate?

While Nix provides excellent reproducibility and declarative configuration, a native Neovim configuration with Lazy.nvim offers:

1. **Simplicity**: No need to understand Nix language and concepts
2. **Performance**: Direct plugin loading without Nix indirection
3. **Compatibility**: Works on any system without requiring Nix
4. **Updates**: Easier to update plugins and configurations
5. **Community**: Broader compatibility with the Neovim ecosystem
6. **Integration**: Better integration with tools like tmux

## Migration Steps

### 1. Backup Your Existing Configuration

Before proceeding, make sure to backup your existing Nix-based configuration:

```bash
# Create a backup of your Nix configuration
cp -r ~/.config/nvim ~/.config/nvim.nix.bak
```

### 2. Install This Configuration

Use the provided installation script:

```bash
./install.sh
```

Or manually install by following the instructions in the README.md.

### 3. Migrate Custom Settings

If you had custom settings in your Nix configuration:

#### Keymaps

- Nix keymaps were defined in `keymaps.nix`
- Now they are in `lua/config/keymaps.lua`
- Format has changed from Nix objects to Lua function calls

Example migration:
```nix
# Nix format (old)
keymaps = [
  {
    mode = "n";
    key = "<leader>ff";
    action = "<cmd>Telescope find_files<CR>";
    options = {
      desc = "Find files";
    };
  }
];
```

```lua
-- Lua format (new)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
```

#### Options

- Nix options were defined in `sets.nix`
- Now they are in `lua/config/options.lua`
- Format has changed from Nix attributes to Lua assignments

Example migration:
```nix
# Nix format (old)
opts = {
  number = true;
  relativenumber = true;
};
```

```lua
-- Lua format (new)
vim.opt.number = true
vim.opt.relativenumber = true
```

#### Plugin Configurations

- Nix plugin configs were spread across multiple .nix files
- Now each plugin has its own file in `lua/plugins/`
- Format has changed from Nix attributes to Lazy.nvim plugin specs

Example migration:
```nix
# Nix format (old)
plugins.telescope = {
  enable = true;
  settings = {
    defaults = {
      prompt_prefix = " ";
    };
  };
};
```

```lua
-- Lua format (new)
return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require("telescope").setup({
      defaults = {
        prompt_prefix = " ",
      }
    })
  end,
}
```

### 4. Adding Custom Plugins

To add a custom plugin that was in your Nix configuration:

1. Create a new file in `lua/plugins/` for your plugin
2. Use the Lazy.nvim plugin spec format
3. Configure the plugin in the same file

Example:
```lua
-- lua/plugins/custom-plugin.lua
return {
  "username/custom-plugin",
  config = function()
    require("custom-plugin").setup({
      -- Your configuration here
    })
  end,
}
```

### 5. Tmux Integration

This configuration includes seamless navigation between Neovim and tmux:

1. The `vim-tmux-navigator` plugin is configured in `lua/plugins/tmux.lua`
2. A tmux configuration is provided in `tmux.conf`
3. The installation script will install both configurations

If you want to manually set up the tmux integration:

```bash
# Copy the tmux configuration
cp tmux.conf ~/.tmux.conf

# Install the tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux and install plugins with prefix + I
```

The integration allows you to use `Ctrl+h/j/k/l` to navigate between Neovim splits and tmux panes seamlessly.

## Troubleshooting

If you encounter issues after migration:

1. Check the Neovim logs: `:messages`
2. Use `:checkhealth` to diagnose problems
3. Ensure all required dependencies are installed
4. Compare your custom configurations with the examples

### Tmux Integration Issues

If the tmux integration is not working:

1. Make sure you have tmux installed
2. Check that the tmux plugin manager is installed
3. Verify that the tmux configuration is correctly loaded
4. Restart tmux and Neovim

## Getting Help

If you need assistance with the migration:

1. Open an issue in this repository
2. Refer to the [Lazy.nvim documentation](https://github.com/folke/lazy.nvim)
3. Check the [Neovim documentation](https://neovim.io/doc/)
4. For tmux issues, see the [vim-tmux-navigator documentation](https://github.com/christoomey/vim-tmux-navigator) 