{
  description = "My nVIM config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Get version 0.10 of neovim
    nvim-master = {
      url = "github:neovim/neovim";
      flake = false;
    };
  };

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          overlay = final: prev: {
            neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
              version = "0.10";
              src = nvim-master;
            });
          };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [overlay];
          };
          configMod = {pkgs, ...}: {
            imports = [
              ./sets.nix
              ./keymaps.nix
              ./telescope/telescope.nix
              ./utils/project.nix
              ./utils/whichkey.nix
              ./utils/harpoon.nix
              ./ui/notify.nix
              ./ui/alpha.nix
              ./ui/indent-blankline.nix
              ./ui/noice.nix
              ./ui/nui.nix
              ./statusline/lualine.nix
              ./statusline/statline.nix
              ./colorschemes/catppuccin.nix
              ./git/lazygit.nix
              ./git/gitsigns.nix
              ./languages/nvim-lint.nix
              ./languages/treesitter/treesitter-context.nix
              ./languages/treesitter/treesitter-textobjects.nix
              ./languages/treesitter/treesitter.nix
              ./lsp/conform.nix
              ./lsp/fidget.nix
              ./lsp/lsp.nix
              ./lsp/lspsaga.nix
              ./lsp/trouble.nix
              ./completions/cmp.nix
              ./completions/lspkind.nix
              ./snippets/luasnip.nix
            ];
            extraPackages = with pkgs; [
              ripgrep
              nixd
              lazygit
              statix
              alejandra
              codespell
            ];
            plugins.trouble.enable = true;
            plugins.treesitter.enable = true;
            extraPlugins = with pkgs.vimPlugins; [
              vim-just
            ];
          };
          nixvim' = nixvim.legacyPackages."${system}";
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = configMod;
            extraSpecialArgs = {
              inherit pkgs;
            };
          };
          tmuxWrapper = pkgs.writeShellScript "tmuxWrapper" ''
            ${pkgs.tmux}/bin/tmux -f ${./tmux.conf} "$@"
          '';
        in {
          formatter = nixpkgs.legacyPackages.${system}.alejandra;
          checks = {
            default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "Navet"; # Inspiration taken from Neve
            };
          };
          packages = {
            inherit nvim;
            default = nvim;
          };
          apps = {
            tmux = {
              type = "app";
              program = "${tmuxWrapper}";
            };
          };
        }
      );
}
