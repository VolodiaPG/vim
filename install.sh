#!/usr/bin/env bash

# Neovim Configuration Installation Script

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
    echo -e "${BLUE}[NVIM CONFIG]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if Neovim is installed
check_neovim() {
    if ! command -v nvim &>/dev/null; then
        print_error "Neovim is not installed. Please install Neovim 0.9.0 or later."
        exit 1
    fi

    # Check Neovim version
    nvim_version=$(nvim --version | head -n 1 | cut -d " " -f 2)
    if [[ $(echo "$nvim_version 0.9.0" | tr " " "\n" | sort -V | head -n 1) != "0.9.0" ]]; then
        print_warning "Neovim version $nvim_version detected. This configuration requires Neovim 0.9.0 or later."
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "Neovim $nvim_version detected."
    fi
}

# Check if LazyGit is installed
check_lazygit() {
    if ! command -v lazygit &>/dev/null; then
        print_warning "LazyGit is not installed. Some features will not work."
        print_message "You can install LazyGit from: https://github.com/jesseduffield/lazygit#installation"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "LazyGit is installed."
    fi
}

# Check if ripgrep is installed
check_ripgrep() {
    if ! command -v rg &>/dev/null; then
        print_warning "ripgrep is not installed. Telescope search will not work properly."
        print_message "You can install ripgrep from: https://github.com/BurntSushi/ripgrep#installation"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "ripgrep is installed."
    fi
}

# Check if tmux is installed
check_tmux() {
    if ! command -v tmux &>/dev/null; then
        print_warning "tmux is not installed. Tmux integration will not work."
        print_message "You can install tmux from: https://github.com/tmux/tmux/wiki/Installing"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "tmux is installed."
    fi
}

# Backup existing Neovim configuration
backup_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        print_message "Backing up existing Neovim configuration..."
        backup_dir="$HOME/.config/nvim.bak.$(date +%Y%m%d%H%M%S)"
        mv "$HOME/.config/nvim" "$backup_dir"
        print_success "Existing configuration backed up to $backup_dir"
    fi
}

# Backup existing tmux configuration
backup_tmux_config() {
    if [ -f "$HOME/.tmux.conf" ]; then
        print_message "Backing up existing tmux configuration..."
        backup_file="$HOME/.tmux.conf.bak.$(date +%Y%m%d%H%M%S)"
        mv "$HOME/.tmux.conf" "$backup_file"
        print_success "Existing tmux configuration backed up to $backup_file"
    fi
    if [ ! -d "$HOME/.config/tmux/plugins/catppuccin" ]; then
        print_message "Installing catppuccin tmux theme..."
        mkdir -p ~/.config/tmux/plugins/catppuccin
        git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
        print_success "catppuccin tmux theme installed successfully!"
    else
        print_message "catppuccin tmux theme already installed, updating..."
	    BACK=$(pwd)
        cd ~/.config/tmux/plugins/catppuccin/tmux
        git pull
	    cd $BACK
        print_success "catppuccin tmux theme updated successfully!"
    fi
}

# Install the configuration
install_config() {
    print_message "Installing Neovim configuration..."

    # Create the nvim config directory
    mkdir -p "$HOME/.config/nvim"

    # Copy all files to the nvim config directory
    cp -r ./* "$HOME/.config/nvim/"

    print_success "Configuration installed successfully!"
}

# Install tmux configuration
install_tmux_config() {
    print_message "Installing tmux configuration..."

    # Copy tmux.conf to home directory
    cp ./tmux.conf "$HOME/.tmux.conf"

    print_success "tmux configuration installed successfully!"
}

# Main function
main() {
    print_message "Starting Neovim configuration installation..."

    # Check requirements
    check_neovim
    check_lazygit
    check_ripgrep
    check_tmux

    # Confirm installation
    echo
    print_message "This will install the Neovim configuration to ~/.config/nvim"
    print_message "and tmux configuration to ~/.tmux.conf"
    print_message "Any existing configurations will be backed up."
    read -p "Continue with installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_message "Installation cancelled."
        exit 0
    fi

    # Backup and install
    backup_config
    backup_tmux_config
    install_config
    install_tmux_config

    echo
    print_success "Installation complete!"
    print_message "Start Neovim with 'nvim' to initialize the plugins."
    print_message "Start tmux with 'tmux' and press prefix + I to install tmux plugins."
    print_message "Enjoy your new Neovim and tmux configuration!"
}

# Run the main function
main
